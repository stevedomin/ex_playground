defmodule ExPlayground.SnippetTest do
  use ExPlayground.ModelCase

  alias ExPlayground.Snippet

  @valid_attrs %{id: "1", content: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Snippet.changeset(%Snippet{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Snippet.changeset(%Snippet{}, @invalid_attrs)
    refute changeset.valid?
  end
end
