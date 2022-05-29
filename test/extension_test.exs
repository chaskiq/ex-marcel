defmodule ExtensionTest do
  use ExUnit.Case
  doctest ExMarcel

  test "ignores case and any preceding dot" do
    assert "application/pdf" = ExMarcel.MimeType.for(nil, extension: "PDF")
    assert "application/pdf" = ExMarcel.MimeType.for(nil, extension: ".PDF")
    assert "application/pdf" = ExMarcel.MimeType.for(nil, extension: "pdf")
    assert "application/pdf" = ExMarcel.MimeType.for(nil, extension: ".pdf")
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
