defmodule ExPlayground.CodeServerTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = ExPlayground.CodeServer.start_link
    {:ok, bucket: bucket}
  end

  test "stores code snippet by key", %{bucket: bucket} do
    assert ExPlayground.CodeServer.get(bucket, "aaa") == nil

    ExPlayground.CodeServer.put(bucket, "abc", "IO.puts")
    assert ExPlayground.CodeServer.get(bucket, "abc") == "IO.puts"
  end
  
  test "delete code snippet at key", %{bucket: bucket} do
    ExPlayground.CodeServer.put(bucket, "abc", "IO.puts")
    assert ExPlayground.CodeServer.delete(bucket, "abc") == "IO.puts"
    assert ExPlayground.CodeServer.get(bucket, "abc") == nil
  end
end
