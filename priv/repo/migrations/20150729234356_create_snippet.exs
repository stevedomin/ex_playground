defmodule ExPlayground.Repo.Migrations.CreateSnippet do
  use Ecto.Migration

  def change do
    create table(:snippets, primary_key: false) do
      add :id, :string, size: 40, primary_key: true
      add :content, :text, null: false

      timestamps
    end

  end
end
