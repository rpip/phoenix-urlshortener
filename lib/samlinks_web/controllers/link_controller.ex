defmodule SamlinksWeb.LinkController do
  use SamlinksWeb, :controller

  alias Samlinks.{Links, Hash, Indexer}

  action_fallback SamlinksWeb.FallbackController

  def index(conn, _params) do
    links = Links.list_links()
    render(conn, "index.json", links: links)
  end

  def create(conn, %{"url" => url} = _link_params) do
    link_params = Map.new([url: url, slug: Hash.generate()])
    Indexer.save!(link_params)

    conn
    |> put_status(:created)
    |> render("show.json", link: link_params)
  end

  def show(conn, %{"slug" => slug}) do
    link = Links.get_link!(slug)
    ip = to_string(:inet_parse.ntoa(conn.remote_ip))
    Indexer.log_visit(link, ip, Map.new(conn.req_headers))

    url =
      link.url
      |> URI.decode
      |> Samlinks.rebuild_url(conn.query_params)

    redirect(conn, external: url)
  end
end
