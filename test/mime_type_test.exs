defmodule MimeTypeTest do
  use ExUnit.Case, async: true

  alias ExMarcel.MimeType

  doctest ExMarcel

  setup do
    # @path = files("image.gif").to_s
    {:ok, path: TestHelpers.files("image.gif")}
  end

  test "gets content type from Files", %{path: path} do
    {:ok, file} = File.open(path)
    content_type = MimeType.for({:io, file})
    assert "image/gif" == content_type
    # content_type = File.open @path do |file|
    #  Marcel::MimeType.for file
    # end
    # assert_equal "image/gif", content_type
  end

  test "gets content type from Fileskk" do
    {:ok, file} = File.open(TestHelpers.files("magic/video/webm/webm.mkv"))
    content_type = MimeType.for({:io, file})
    assert "video/webm" == content_type
    # content_type = File.open @path do |file|
    #  Marcel::MimeType.for file
    # end
    # assert_equal "image/gif", content_type
  end

  test "gets content type from x-log" do
    {:ok, file} = File.open(TestHelpers.files("name/text/x-log/x-log.log"))
    content_type = MimeType.for({:io, file}, declared_type: "text/x-log")
    assert "text/x-log" == content_type
    # content_type = File.open @path do |file|
    #  Marcel::MimeType.for file
    # end
    # assert_equal "image/gif", content_type
  end

  test "gets content type from tif" do
    {:ok, file} = File.open(TestHelpers.files("magic/image/tiff/tiff.tif"))
    content_type = MimeType.for({:io, file})
    assert "image/tiff" == content_type
    # content_type = File.open @path do |file|
    #  Marcel::MimeType.for file
    # end
    # assert_equal "image/gif", content_type
  end

  test "gets content type from Pathnames", %{path: path} do
    content_type = MimeType.for({:path, path})
    assert("image/gif" == content_type)
  end

  test "closes Pathname files after use", %{path: _path} do
    # content_type = Marcel::MimeType.for Pathname.new(@path)
    # open_files = ObjectSpace.each_object(File).reject(&:closed?)
    # assert open_files.none? { |f| f.path == @path }
  end

  test "gets content type from Tempfiles", %{path: _path} do
    # Tempfile.open("Marcel") do |tempfile|
    #  tempfile.write(File.read(@path))
    #  content_type = Marcel::MimeType.for tempfile
    #  assert_equal "image/gif", content_type
    # end
  end

  test "gets content type from IOs", %{path: path} do
    string = File.read!(path)
    content_type = MimeType.for({:string, string})
    assert "image/gif" == content_type
    # io = StringIO.new(File.read(@path))
    # content_type = Marcel::MimeType.for io
    # assert_equal "image/gif", content_type
  end

  test "gets content type from sources that conform to Rack::Lint::InputWrapper", %{path: _path} do
    # io = StringIO.new(File.read(@path))
    # wrapper = Rack::Lint::InputWrapper.new(io)
    # content_type = Marcel::MimeType.for wrapper
    # assert_equal "image/gif", content_type
  end
end
