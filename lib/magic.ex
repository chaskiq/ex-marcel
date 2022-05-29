# frozen_string_literal: true

# Code in this file adapted from the mimemagic gem, released under the MIT License.
# Copyright (c) 2011 Daniel Mendler. Available at https://github.com/mimemagicrb/mimemagic.

defmodule ExMarcel.Magic do
  # Mime type detection
  # attr_reader :type, :mediatype, :subtype

  defstruct [:type, :mediatype, :subtype]
  alias ExMarcel.TableWrapper

  # Mime type by type string
  def new(type) do
    # @type = type
    # @mediatype, @subtype = type.split('/', 2)

    [mediatype, subtype] = String.split(type, "/")

    %__MODULE__{
      type: type,
      mediatype: mediatype,
      subtype: subtype
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
    options = Keyword.merge(defaults, options) |> Enum.into(%{})

    extensions = options.extensions

    new_extensions = TableWrapper.type_exts() |> Map.put(type, extensions)

    ExMarcel.TableWrapper.put("type_exts", new_extensions)
    # extensions = [options[:extensions]].flatten.compact
    # TYPE_EXTS[type] = extensions
    case options.parents do
      [] ->
        nil

      _ ->
        new_parents = TableWrapper.type_parents() |> Map.put(type, options.parents)

        TableWrapper.put("type_parents", new_parents)
    end

    # parents = [options[:parents]].flatten.compact
    # TYPE_PARENTS[type] = parents unless parents.empty?

    table_extensions = TableWrapper.extensions()

    new_table_extensions =
      Enum.reduce(extensions, table_extensions, fn ext, acc ->
        Map.put(acc, ext, type)
      end)

    TableWrapper.put("extensions", new_table_extensions)
    # extensions.each {|ext| EXTENSIONS[ext] = type }
    if options[:magic] do
      TableWrapper.put("magic", [type, options.magic] ++ TableWrapper.magic())
    end

    # MAGIC.unshift [type, options[:magic]] if options[:magic]
  end

  # Removes a mime type from the dictionary.  You might want to do this if
  # you're seeing impossible conflicts (for instance, application/x-gmc-link).
  # * <i>type</i>: The mime type to remove.  All associated extensions and magic are removed too.
  def remove(struct, type) do
    # TableWrapper.extensions() |> Map.delete(map, :b)

    # EXTENSIONS.delete_if {|ext, t| t == type }
    # MAGIC.delete_if {|t, m| t == type }
    # TYPE_EXTS.delete(type)
    # TYPE_PARENTS.delete(type)
  end

  # Returns true if type is a text format
  def text?(struct) do
    # mediatype == 'text' || child_of?('text/plain');
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
    # self.class.child?(type, parent)
    child?(struct.type, parent)
  end

  # Get string list of file extensions
  def extensions(struct) do
    TableWrapper.type_exts() |> Map.get(struct.type) || []
    # TYPE_EXTS[type] || []
  end

  # Get mime comment
  def comment(struct) do
    # deprecated
    nil
  end

  # Lookup mime type by file extension
  def by_extension(ext) do
    ext = ext |> String.downcase()

    mime =
      case ext |> String.slice(0..0) do
        "." ->
          ext = ext |> String.slice(1..-1)
          TableWrapper.extensions() |> Map.get(ext)

        _ ->
          TableWrapper.extensions() |> Map.get(ext)
      end

    mime && __MODULE__.new(mime)

    # ext = ext.to_s.downcase
    # mime = ext[0..0] == '.' ? EXTENSIONS[ext[1..-1]] : EXTENSIONS[ext]
    # mime && new(mime)
  end

  # Lookup mime type by filename
  def by_path(path) do
    by_extension(Path.extname(path))
    # by_extension(File.extname(path))
  end

  # Lookup mime type by magic content analysis.
  # This is a slow operation.
  def by_magic(io) do
    mime = magic_match(io, :find)
    mime && new(mime[0])
  end

  # Lookup all mime types by magic content analysis.
  # This is a slower operation.
  def all_by_magic(io) do
    require IEx
    IEx.pry()
    # magic_match(io, :select).map { |mime| new(mime[0]) }
  end

  # Return type as string
  def to_s(struct) do
    # type
    struct.type
  end

  # Allow comparison with string
  def eql?(struct, other) do
    # type == other.to_s
    struct.type == to_s(other)
  end

  def hash(struct) do
    # type.hash
  end

  # alias == eql?

  def child?(child, parent) do
    require IEx
    IEx.pry()
    child == parent || TableWrapper.type_parents()
    # child == parent || TYPE_PARENTS[child]&.any? {|p| child?(p, parent) }
  end

  def magic_match(io, method) do
    nil
    # return magic_match(StringIO.new(io.to_s), method) unless io.respond_to?(:read)

    # io.binmode if io.respond_to?(:binmode)
    # io.set_encoding(Encoding::BINARY) if io.respond_to?(:set_encoding)
    # buffer = "".encode(Encoding::BINARY)
    require IEx
    IEx.pry()
    # MAGIC.send(method) { |type, matches| magic_match_io(io, matches, buffer) }
  end

  def magic_match_io(io, matches, buffer) do
    # matches.any? do |offset, value, children|
    #   match =
    #     if value
    #       if Range === offset
    #         io.read(offset.begin, buffer)
    #         x = io.read(offset.end - offset.begin + value.bytesize, buffer)
    #         x && x.include?(value)
    #       else
    #         io.read(offset, buffer)
    #         io.read(value.bytesize, buffer) == value
    #       end
    #     end

    #   io.rewind
    #   match && (!children || magic_match_io(io, children, buffer))
    # end
  end

  # private_class_method :magic_match, :magic_match_io
end
