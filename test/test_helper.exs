# ExUnit.start()
ExUnit.start(timeout: 100_000_000)

ExMarcel.TableWrapper.start_link([])

defmodule FlatFiles do
  def list_all(filepath) do
    _list_all(filepath)
  end

  defp _list_all(filepath) do
    if String.contains?(filepath, ".git") do
      []
    else
      expand(File.ls(filepath), filepath)
    end
  end

  defp expand({:ok, files}, path) do
    files
    |> Enum.flat_map(&_list_all("#{path}/#{&1}"))
  end

  defp expand({:error, _}, path) do
    [path]
  end
end

defmodule TestHelpers do
  def fixture_path(name) do
    "./test/fixtures/#{name}"
  end

  def files(name) do
    fixture_path(name)
  end

  def each_content_type_fixture_array(folder) do
    FlatFiles.list_all(fixture_path(folder))
    |> Enum.map(fn name ->
      name = String.replace(name, "#{fixture_path(folder)}/", "")

      regex = ~r"\A([^\/]+\/[^\/]*)\/?(.*)\.(\w+)\Z"

      [_, content_type, extra, _extension] = Regex.run(regex, name)

      size = content_type |> String.length()

      _extra =
        if content_type |> String.slice(-size..-1) != extra do
          extra
        end

      [files("#{folder}/#{name}"), name, content_type]
    end)
  end

  def each_content_type_fixture(folder, block \\ nil) do
    FlatFiles.list_all(fixture_path(folder))
    |> Enum.each(fn name ->
      name = String.replace(name, "#{fixture_path(folder)}/", "")

      regex = ~r"\A([^\/]+\/[^\/]*)\/?(.*)\.(\w+)\Z"

      [_, content_type, extra, _extension] = Regex.run(regex, name)

      size = content_type |> String.length()

      _extra =
        if content_type |> String.slice(-size..-1) != extra do
          extra
        end

      if block do
        block.([files("#{folder}/#{name}"), name, content_type])
      end
    end)
  end
end
