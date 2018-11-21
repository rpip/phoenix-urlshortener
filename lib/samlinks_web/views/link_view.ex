defmodule SamlinksWeb.LinkView do
  use SamlinksWeb, :view
  alias SamlinksWeb.LinkView
  import Samlinks, only: [pretty_url: 1]

  def render("index.json", %{links: links}) do
    %{data: render_many(links, LinkView, "link.json")}
  end

  def render("show.json", %{link: link}) do
    %{data: render_one(link, LinkView, "link.json")}
  end

  def render("link.json", %{link: link}) do
    %{link: pretty_url(link.slug), url: link.url, slug: link.slug}
  end
end
