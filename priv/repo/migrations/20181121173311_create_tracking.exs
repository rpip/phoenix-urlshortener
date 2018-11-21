defmodule Samlinks.Repo.Migrations.CreateTracking do
  use Ecto.Migration

  def change do
    create table(:tracking) do
      add :meta, :map
      add :ip, :string
      add :link_id, references(:links, on_delete: :nothing)

      timestamps()
    end

    create index(:tracking, [:link_id])
  end
end
