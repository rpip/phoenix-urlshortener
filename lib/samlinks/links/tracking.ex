defmodule Samlinks.Links.Tracking do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tracking" do
    field :ip, :string
    field :meta, :map
    belongs_to :link, Samlinks.Links.Link

    timestamps()
  end

  @doc false
  def changeset(tracking, attrs) do
    tracking
    |> cast(attrs, [:meta, :ip, :link_id])
    |> validate_required([:meta, :ip, :link_id])
  end
end
