defmodule ExMarcelTest do
  use ExUnit.Case
  doctest ExMarcel

  test "greets the world" do
    assert ExMarcel.hello() == :world
  end
end
