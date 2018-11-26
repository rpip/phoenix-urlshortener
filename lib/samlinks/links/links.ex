defmodule Samlinks.Links do
  @moduledoc """
  The Links context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Adapters.SQL
  alias Samlinks.Repo

  alias Samlinks.Links.{Link, Tracking}

  @doc """
  Returns the list of links.

  ## Examples

      iex> list_links()
      [%Link{}, ...]

  """
  def list_links do
    Repo.all(Link)
  end

  @doc """
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link!("8fghj7tyu")
      %Link{}

      iex> get_link!(456)
      ** (Ecto.NoResultsError)

  """
  def get_link!(slug), do: Repo.get_by!(Link, slug: slug)

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a link.

  ## Examples

      iex> update_link(link, %{field: new_value})
      {:ok, %Link{}}

      iex> update_link(link, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Link.

  ## Examples

      iex> delete_link(link)
      {:ok, %Link{}}

      iex> delete_link(link)
      {:error, %Ecto.Changeset{}}

  """
  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking link changes.

  ## Examples

      iex> change_link(link)
      %Ecto.Changeset{source: %Link{}}

  """
  def change_link(%Link{} = link) do
    Link.changeset(link, %{})
  end

  def log_visit(link, attrs \\ %{}) do
    %Tracking{}
    |> Tracking.changeset(Map.put(attrs, :link_id, link.id))
    |> Repo.insert!
  end

  def prunable_links do
    sql = """
    SELECT l.*
    FROM links l
    LEFT JOIN tracking t
    ON l.id = t.link_id
    WHERE t.link_id IS NULL
    AND l.inserted_at > NOW() - INTERVAL '30 days'
    """
    result = SQL.query!(Repo, sql)
    Enum.map(result.rows, &Repo.load(Link, {result.columns, &1}))
  end

  @doc "Deletes all unvisisted links"
  def prune_links do
    prunable_links() |> Enum.map(&Repo.delete!/1)
  end
end
