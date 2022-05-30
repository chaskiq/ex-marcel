defmodule NameTest do
  use ExUnit.Case
  doctest ExMarcel

  test "gets type for content_type by filename from name" do
    TestHelpers.each_content_type_fixture("name", fn [file, name, content_type] ->
      # IO.inspect("#{content_type}, #{ExMarcel.MimeType.for(nil, name: file)}")
      assert content_type == ExMarcel.MimeType.for(nil, name: file)
    end)
  end
end
