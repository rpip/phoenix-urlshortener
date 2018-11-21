defmodule Samlinks do
  @moduledoc """
  Samlinks keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  @hostname Application.get_env(:samlinks, :hostname)
  @placeholder_regex ~r/<%(.*?)%>/

  @doc """
  Returns a full url link with the configured hostname

  ## Examples

  iex> pretty_url("foo")
  s.am/foo
  """
  def pretty_url(slug) do
    Path.join(@hostname, slug)
  end


  @doc """
  Returns all placeholders in the url

  ## Examples

  iex> url = "http://example.com/about/index.html?uid=<%token%>&email=<%email%>&city=<%city%>"
  iex> scan_placeholders(url)
  %{"city" => "<%city%>", "email" => "<%email%>", "token" => "<%token%>"}

  """
  def scan_placeholders(url) do
    case Regex.scan(@placeholder_regex, url) do
      [] -> %{}
      match ->
        match
        |> Enum.map(fn [v,k|_] -> {k, v} end)
        |> Enum.into(%{})
    end
  end


  @doc """
  Returns the reconstructed URL by replacing placeholders with given values

  ## Examples

  iex> url = "s.am/about?uid=<%token%>&city=<%city%>"
  iex> params = %{"city" => "accra", token" => "<%token%>"}
  iex> rebuild_url(url, params)
  s.am/about?city=accra&token=987678
  """
  def rebuild_url(url, params \\ %{}) do
    params = scan_placeholders(url) |> Map.merge(params)
    new_url = %{URI.parse(url) | query: URI.encode_query(params)}
    "#{new_url}"
  end
end
