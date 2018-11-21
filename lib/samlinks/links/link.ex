defmodule Samlinks.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  alias Samlinks.Hash

  schema "links" do
    field :url, :string
    field :slug, :string
    has_many :visits, Samlinks.Links.Tracking

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :slug])
    |> validate_required([:url])
    |> validate_url(:url)
    |> put_change(:slug, Hash.generate())
    |> unique_constraint(:slug)
  end

  defp validate_uri(uri) do
    case URI.parse(uri) do
      %URI{scheme: nil} -> {:error, uri}
      %URI{host: nil} -> {:error, uri}
      %URI{path: nil} -> {:error, uri}
      uri -> {:ok, uri}
    end
  end

  defp validate_url(changeset, field) do
    case changeset.valid? do
      true ->
        url = get_field(changeset, field)
        case validate_uri(url) do
          {:ok, _} -> put_change(changeset, :url, URI.encode(url))
          _ -> add_error(changeset, :url, "Invalid URL")
        end
      _ ->
        changeset
    end
  end
end
