defmodule ExMarcelTest do
  use ExUnit.Case
  doctest ExMarcel

  test "greets the world" do
    assert ExMarcel.hello() == :world
  end

  test "for" do
    TestHelpers.each_content_type_fixture("name", fn [file, name, content_type] ->
      # require IEx
      # IEx.pry()
      IO.inspect("#{content_type}, #{ExMarcel.MimeType.for(nil, name: file)}")
      assert content_type == ExMarcel.MimeType.for(nil, name: file)
    end)
  end
end
