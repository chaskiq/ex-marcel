defmodule MagicAndNameTest do
  use ExUnit.Case, async: true
  doctest ExMarcel
  alias ExMarcel.{MimeType}

  test "correctly returns content_type for name given both file and name" do
    # All fixtures that can be recognised by name should also be recognisable when given
    # the file contents and the name. In some cases, the file contents will point to a
    # generic type, while the name will choose a more specific subclass
    TestHelpers.each_content_type_fixture("name", fn [file, name, content_type] ->
      # IO.inspect("#{file}, #{name}")
      assert content_type == MimeType.for(file, name: name)
    end)
  end
end
