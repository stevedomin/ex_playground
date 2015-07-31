defmodule ExPlayground.Snippet do
  use ExPlayground.Web, :model

  @primary_key {:id, :string, []}

  schema "snippets" do
    field :content, :string

    timestamps
  end

  @required_fields ~w(id content)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def find_or_create(params) do
    case ExPlayground.Repo.get(__MODULE__, params["id"]) do
      nil ->
        changeset(%ExPlayground.Snippet{}, params)
        |> ExPlayground.Repo.insert
      snippet -> {:ok, snippet}
    end
  end
end

