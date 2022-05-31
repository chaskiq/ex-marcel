defmodule MagicTest do
  use ExUnit.Case, async: true
  doctest ExMarcel
  alias ExMarcel.{MimeType}

  test "gets type for content_type by using only magic bytes name" do
    # These fixtures should be recognisable given only their contents. Where a generic type
    # has more specific subclasses (such as application/zip), these subclasses cannot usually
    # be recognised by magic alone; their name is also needed to correctly identify them.

    # TestHelpers.each_content_type_fixture("magic", fn [file, name, content_type] ->
    #  IO.inspect("gets type for #{content_type} by using only magic bytes #{name}")
    #  assert content_type == MimeType.for(file)
    # end)

    TestHelpers.each_content_type_fixture("magic", fn [file, _name, content_type] ->
      # if content_type != MimeType.for(file) do
      #  IO.inspect(" NOT MATCHES FOR #{name}")
      #  assert
      # end

      assert content_type == MimeType.for({:path, file})

      # test "gets type for #{content_type} by using only magic bytes #{name}" do
      #  IO.inspect(" NOT MATCHES FOR #{unquote(name)}")
      #  content_type != MimeType.for(unquote(file))
      # end
    end)
  end
end
