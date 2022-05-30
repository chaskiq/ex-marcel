defmodule MagicAndDeclaredTypeTest do
  use ExUnit.Case, async: true
  doctest ExMarcel
  alias ExMarcel.{MimeType}

  test "correctly returns content_type for name given both file and declared type" do
    TestHelpers.each_content_type_fixture("name", fn [file, _name, content_type] ->
      # IO.inspect("#{file}, #{content_type}")
      assert content_type == MimeType.for(file, declared_type: content_type)
    end)
  end
end
