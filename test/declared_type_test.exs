defmodule DeclaredTypeTest do
  use ExUnit.Case, async: true
  # doctest ExMarcel
  alias ExMarcel.MimeType

  test "returns declared type as last resort" do
    assert "text/html" ==
             MimeType.for(nil, name: "unrecognisable", declared_type: "text/html")
  end

  test "returns application/octet-stream if declared type empty or unrecognised" do
    assert "application/octet-stream" == MimeType.for(nil, declared_type: "")
    assert "application/octet-stream" == MimeType.for(nil, declared_type: "unrecognised")
  end

  test "ignores charset declarations" do
    assert "text/html" == MimeType.for(nil, declared_type: "text/html; charset=utf-8")
  end
end
