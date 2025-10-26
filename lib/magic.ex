# Code in this file adapted from the mimemagic gem, released under the MIT License.
# Copyright (c) 2011 Daniel Mendler. Available at https://github.com/mimemagicrb/mimemagic.

defmodule ExMarcel.Magic do
  alias ExMarcel.TableWrapper

  defstruct [:mediatype, :subtype, :type]

  # Mime type by type string
  def new(type) do
    [mediatype, subtype] = String.split(type, "/")

    %__MODULE__{
      mediatype: mediatype,
      subtype: subtype,
      type: type
    }
  end

  # Add custom mime type. Arguments:
  # * <i>type</i>: Mime type
  # * <i>options</i>: Options hash
  #
  # Option keys:
  # * <i>:extensions</i>: String list or single string of file extensions
  # * <i>:parents</i>: String list or single string of parent mime types
  # * <i>:magic</i>: Mime magic specification
  # * <i>:comment</i>: Comment string
  def add(type, options \\ []) do
    defaults = [extensions: nil, magic: nil, parents: nil]
    options = Keyword.merge(defaults, options) |> Map.new()

    extensions = options.extensions

    new_extensions = TableWrapper.type_exts() |> Map.put(type, extensions)

    ExMarcel.TableWrapper.put("type_exts", new_extensions)

    case options.parents do
      [] ->
        nil

      _ ->
        new_parents = TableWrapper.type_parents() |> Map.put(type, options.parents)

        TableWrapper.put("type_parents", new_parents)
    end

    table_extensions = TableWrapper.extensions()

    new_table_extensions =
      Enum.reduce(extensions, table_extensions, fn ext, acc ->
        Map.put(acc, ext, type)
      end)

    TableWrapper.put("extensions", new_table_extensions)

    if options[:magic] do
      TableWrapper.put("magic", [[type, options.magic] | TableWrapper.magic()])
    end
  end

  # Removes a mime type from the dictionary.  You might want to do this if
  # you're seeing impossible conflicts (for instance, application/x-gmc-link).
  # * <i>type</i>: The mime type to remove.  All associated extensions and magic are removed too.
  def remove(_struct, _type) do
    # TableWrapper.extensions() |> Map.delete(map, :b)

    # EXTENSIONS.delete_if {|ext, t| t == type }
    # MAGIC.delete_if {|t, m| t == type }
    # TYPE_EXTS.delete(type)
    # TYPE_PARENTS.delete(type)
  end

  # Returns true if type is a text format
  def text?(struct) do
    struct.mediatype.text || child_of?(struct, "text/plain")
  end

  # Mediatype shortcuts
  def image?(struct) do
    struct.mediatype == "image"
  end

  def audio?(struct) do
    struct.mediatype == "audio"
  end

  def video?(struct) do
    struct.mediatype == "video"
  end

  # Returns true if type is child of parent type
  def child_of?(struct, parent) do
    child?(struct.type, parent)
  end

  # Get string list of file extensions
  def extensions(struct) do
    TableWrapper.type_exts() |> Map.get(struct.type) || []
  end

  # Get mime comment
  def comment(_struct) do
    # deprecated
    nil
  end

  # Lookup mime type by file extension
  def by_extension(ext) do
    ext = ext |> String.downcase()

    mime =
      case ext |> String.slice(0..0) do
        "." ->
          ext = ext |> String.slice(1..-1//1)
          TableWrapper.extensions() |> Map.get(ext)

        _ ->
          TableWrapper.extensions() |> Map.get(ext)
      end

    mime && __MODULE__.new(mime)
  end

  # Lookup mime type by filename
  def by_path(path) do
    by_extension(Path.extname(path))
  end

  # Lookup mime type by magic content analysis.
  # This is a slow operation.
  def by_magic(io) do
    mime = magic_match(io, :find)

    case mime do
      [type, _] -> new(type)
      _ -> nil
    end
  end

  # Lookup all mime types by magic content analysis.
  # This is a slower operation.
  def all_by_magic(_io) do
    # magic_match(io, :select).map { |mime| new(mime[0]) }
  end

  # Return type as string
  def to_s(struct) do
    struct.type
  end

  # Allow comparison with string
  def eql?(struct, other) do
    struct.type == to_s(other)
  end

  def hash(_struct) do
    # type.hash
  end

  # alias == eql?

  def child?(child, parent) do
    child == parent || TableWrapper.type_parents()
    # child == parent || TYPE_PARENTS[child]&.any? {|p| child?(p, parent) }
  end

  def magic_match(io, method) do
    case method do
      :find ->
        TableWrapper.magic()
        |> Enum.find(nil, fn [type, matches] ->
          # IO.puts("MAGIC MATCH FOR: #{type}")
          magic_match_io(io, matches, "", type)
        end)

      _ ->
        raise "no valid method for search magic bytes!"
    end
  end

  def magic_match_io(io, matches, buffer, type) do
    process_io = fn offset, value, children ->
      if value do
        value =
          cond do
            is_list(value) ->
              # IO.inspect(value, binaries: :as_strings)
              List.first(value)

            is_nil(value) ->
              ""

            true ->
              value
          end

        cond do
          offset |> is_integer() ->
            # read first to skip buffer
            IO.binread(io, offset)
            buffer = IO.binread(io, byte_size(value))

            if buffer == value do
              [true, children]
            else
              [false, children]
            end

          # here we ask for a range
          offset.__struct__ == Range ->
            # Skip to the start of the range
            IO.binread(io, offset.first)
            # Read from offset.first to offset.last plus value size
            x = IO.binread(io, offset.last - offset.first + byte_size(value))

            case x do
              :eof ->
                [false, children]

              _ ->
                result = String.contains?(x, value)
                [result, children]
            end

          true ->
            [false, children]
        end
      else
        [false, children]
      end
    end

    matches
    |> Enum.any?(fn x ->
      [match, children] =
        case x do
          [offset, value, children] ->
            process_io.(offset, value, children)

          [offset, value] ->
            process_io.(offset, value, nil)

          _ ->
            [false, nil]
        end

      :file.position(io, :bof)
      # IO.inspect(match)

      match && (!children || magic_match_io(io, children, buffer, type))
    end)
  end
end
