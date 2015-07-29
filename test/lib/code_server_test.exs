defmodule ExPlayground.CodeServerTest do
  use ExUnit.Case, async: true

  test "stores code snippet by key" do
    assert ExPlayground.CodeServer.get("aaa") == nil

    ExPlayground.CodeServer.put("abc", "IO.puts")
    assert ExPlayground.CodeServer.get("abc") == "IO.puts"
  end

  test "delete code snippet at key" do
    ExPlayground.CodeServer.put("abc", "IO.puts")
    assert ExPlayground.CodeServer.delete("abc") == "IO.puts"
    assert ExPlayground.CodeServer.get("abc") == nil
  end
end
