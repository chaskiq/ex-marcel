defmodule ExMarcel.MimeType do
  alias ExMarcel.{Magic, TableWrapper}

  @binary "application/octet-stream"

  def extend(type, options \\ []) do
    defaults = [extensions: [], parents: [], magic: nil]
    options = Keyword.merge(defaults, options) |> Map.new()

    extensions =
      (array(options.extensions) ++
         (TableWrapper.get("type_exts") |> Map.get(type) |> array()))
      |> Enum.uniq()

    parents =
      (array(options.parents) ++
         (TableWrapper.get("type_parents") |> Map.get(type) |> array()))
      |> Enum.uniq()

    Magic.add(type, extensions: extensions, magic: options.magic, parents: parents)
  end

  @spec array(nil | binary | maybe_improper_list) :: maybe_improper_list
  def array(element) when is_list(element) do
    element
  end

  def array(element) when is_nil(element) do
    []
  end

  def array(element) when is_binary(element) do
    [element]
  end

  # Returns the most appropriate content type for the given file.
  #
  # The first argument should be a +Pathname+ or an +IO+. If it is a +Pathname+, the specified
  # file will be opened first.
  #
  # Optional parameters:
  # * +name+: file name, if known
  # * +extension+: file extension, if known
  # * +declared_type+: MIME type, if known
  #
  # The most appropriate type is determined by the following:
  # * type declared by binary magic number data
  # * type declared by the first of file name, file extension, or declared MIME type
  #
  # If no type can be determined, then +application/octet-stream+ is returned.
  def for(pathname_or_io \\ nil, options \\ []) do
    defaults = [name: nil, extension: nil, declared_type: nil]
    options = Keyword.merge(defaults, options) |> Map.new()

    # if is a path or io handle file open on path
    pathname_or_io =
      case pathname_or_io do
        {:io, pid} ->
          if is_pid(pid) do
            pid
          else
            raise "file is not pid, use File.open"
          end

        {:path, path} ->
          {:ok, file} = File.open(path)
          file

        {:string, string} ->
          {:ok, pid} = :file.open(string, [:ram, :binary])
          pid

        nil ->
          nil
      end

    # cond do
    #  is_binary(pathname_or_io) ->
    #    {:ok, file} = File.open(pathname_or_io)
    #    file

    #  is_pid(pathname_or_io) ->
    #    pathname_or_io

    #  true ->
    #    nil
    # end

    type_from_data = for_data(pathname_or_io)

    fallback_type =
      for_declared_type(options.declared_type) || for_name(options.name) ||
        for_extension(options.extension) || @binary

    if type_from_data do
      most_specific_type(type_from_data, fallback_type)
    else
      fallback_type
    end
  end

  defp for_data(pathname_or_io) do
    if pathname_or_io do
      with_io(pathname_or_io, fn io ->
        if magic = ExMarcel.Magic.by_magic(io) do
          detected_type = magic.type |> String.downcase()

          # If we detected a ZIP file, check if it's actually an Office Open XML document
          case detected_type do
            "application/zip" ->
              case ExMarcel.OfficeXmlDetector.detect(io) do
                {:ok, office_type} -> office_type
                :not_office -> detected_type
              end

            _ ->
              detected_type
          end
        end
      end)
    end
  end

  defp for_name(name) do
    if name do
      if magic = ExMarcel.Magic.by_path(name) do
        magic.type |> String.downcase()
      end
    end
  end

  defp for_extension(extension) do
    if extension do
      if magic = ExMarcel.Magic.by_extension(extension) do
        magic.type |> String.downcase()
      end
    end

    # if extension
    #   if magic = Marcel::Magic.by_extension(extension)
    #     magic.type.downcase
    #   end
    # end
  end

  defp for_declared_type(declared_type) do
    type = parse_media_type(declared_type)

    if type != @binary && !is_nil(type) do
      type |> String.downcase()
    end
  end

  defp with_io(pathname_or_io, block) do
    block.(pathname_or_io)
    # if defined?(Pathname) && pathname_or_io.is_a?(Pathname)
    #   pathname_or_io.open(&block)
    # else
    #   yield pathname_or_io
    # end
  end

  defp parse_media_type(content_type) do
    if content_type do
      result =
        content_type
        |> String.downcase()
        |> String.split(~r/[;,\s]/, parts: 2)

      result =
        case result do
          [t, _] -> t
          [t] -> t
          _ -> nil
        end

      if String.contains?(result, "/") do
        result
      end
    end
  end

  # For some document types (notably Microsoft Office) we recognise the main content
  # type with magic, but not the specific subclass. In this situation, if we can get a more
  # specific class using either the name or declared_type, we should use that in preference
  defp most_specific_type(from_magic_type, fallback_type) do
    intersection =
      MapSet.intersection(
        MapSet.new(root_types(from_magic_type)),
        MapSet.new(root_types(fallback_type))
      )
      |> MapSet.to_list()

    if intersection |> Enum.any?() do
      fallback_type
    else
      from_magic_type
    end
  end

  defp root_types(type) do
    if is_nil(TableWrapper.type_exts()[type]) || is_nil(TableWrapper.type_parents()[type]) do
      [type]
    else
      TableWrapper.type_parents()[type]
      |> Enum.map(fn t ->
        root_types(t)
      end)
      |> List.flatten()
    end
  end
end
