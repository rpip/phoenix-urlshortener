defmodule Samlinks.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :string
      add :slug, :string

      timestamps()
    end

    create unique_index(:links, [:slug])
  end
end
