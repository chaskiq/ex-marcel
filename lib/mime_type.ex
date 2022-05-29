defmodule ExMarcel.MimeType do
  @binary "application/octet-stream"

  def extend(type, options \\ []) do
    defaults = [extensions: [], parents: [], magic: nil]
    options = Keyword.merge(defaults, options)
    require IEx
    IEx.pry()
    # extensions = (Array(extensions) + Array(Marcel::TYPE_EXTS[type])).uniq
    # parents = (Array(parents) + Array(Marcel::TYPE_PARENTS[type])).uniq
    # Magic.add(type, extensions: extensions, magic: magic, parents: parents)
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
    options = Keyword.merge(defaults, options) |> Enum.into(%{})

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
          magic.type |> String.downcase()
        end
      end)
    end

    # if pathname_or_io
    #   with_io(pathname_or_io) do |io|
    #     if magic = Marcel::Magic.by_magic(io)
    #       magic.type.downcase
    #     end
    #   end
    # end
  end

  defp for_name(name) do
    if name do
      if magic = ExMarcel.Magic.by_path(name) do
        magic.type |> String.downcase()
      end
    end

    # if name
    #   if magic = Marcel::Magic.by_path(name)
    #     magic.type.downcase
    #   end
    # end
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

    if type != @binary && !type |> is_nil do
      type |> String.downcase()
    end

    # type = parse_media_type(declared_type)

    # if type != @binary && !type.nil?
    #  type.downcase
    # end
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
        |> String.split(~r/[;,\s]/, 2)

      require IEx
      IEx.pry()
      # result if result && result.index("/")
    end

    # if content_type
    #   result = content_type.downcase.split(/[;,\s]/, 2).first
    #   result if result && result.index("/")
    # end
  end

  # For some document types (notably Microsoft Office) we recognise the main content
  # type with magic, but not the specific subclass. In this situation, if we can get a more
  # specific class using either the name or declared_type, we should use that in preference
  defp most_specific_type(from_magic_type, fallback_type) do
    require IEx
    IEx.pry()
    # if (root_types(from_magic_type) & root_types(fallback_type)).any?
    #   fallback_type
    # else
    #   from_magic_type
    # end
  end

  defp root_types(type) do
    require IEx
    IEx.pry()
    # if TYPE_EXTS[type].nil? || TYPE_PARENTS[type].nil?
    #   [ type ]
    # else
    #   TYPE_PARENTS[type].map {|t| root_types t }.flatten
    # end
  end
end
