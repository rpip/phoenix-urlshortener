defmodule SamlinksWeb.LinkController do
  use SamlinksWeb, :controller

  alias Samlinks.Links
  alias Samlinks.Links.{Link, Tracking}

  action_fallback SamlinksWeb.FallbackController

  def index(conn, _params) do
    links = Links.list_links()
    render(conn, "index.json", links: links)
  end

  def create(conn, %{"url" => _url} = link_params) do
    with {:ok, %Link{} = link} <- Links.create_link(link_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.link_path(conn, :show, link))
      |> render("show.json", link: link)
    end
  end

  def show(conn, %{"slug" => slug}) do
    link = Links.get_link!(slug)
    ip = to_string(:inet_parse.ntoa(conn.remote_ip))

    # run async
    Task.async(fn ->
      Links.log_visit(link, %{ip: ip, meta: Map.new(conn.req_headers)})
    end)

    url =
      link.url
      |> URI.decode
      |> Samlinks.rebuild_url(conn.query_params)

    redirect(conn, external: url)
  end
end
