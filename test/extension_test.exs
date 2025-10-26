defmodule ExtensionTest do
  use ExUnit.Case, async: true

  alias ExMarcel.MimeType

  doctest ExMarcel

  test "ignores case and any preceding dot" do
    assert "application/pdf" = ExMarcel.MimeType.for(nil, extension: "PDF")
    assert "application/pdf" = ExMarcel.MimeType.for(nil, extension: ".PDF")
    assert "application/pdf" = ExMarcel.MimeType.for(nil, extension: "pdf")
    assert "application/pdf" = ExMarcel.MimeType.for(nil, extension: ".pdf")
  end

  test "gets type for content_type given file extension extension" do
    # extensions = []
    TestHelpers.each_content_type_fixture(~c"name", fn [file, _name, content_type] ->
      extension = Path.extname(file)
      assert content_type == MimeType.for(nil, extension: extension)
    end)
  end

  # extensions = []

  # each_content_type_fixture('name') do |file, name, content_type|
  #   extension = File.extname(name)

  #   unless extensions.include?(extension)
  #     test "gets type for #{content_type} given file extension #{extension}" do
  #       assert_equal content_type, Marcel::MimeType.for(extension: extension)
  #     end

  #     extensions << extension
  #   end
  # end
end
