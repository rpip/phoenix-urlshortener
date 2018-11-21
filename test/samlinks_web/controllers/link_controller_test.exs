defmodule SamlinksWeb.LinkControllerTest do
  use SamlinksWeb.ConnCase

  alias Samlinks.Links
  alias Samlinks.Links.Link

  @create_attrs %{
	"url": "http://example.com/about/index.html?uid=<%token%>&email=<%email%>&city=<%city%>"
  }

  @invalid_attrs %{}

  def fixture(:link) do
    {:ok, link} = Links.create_link(@create_attrs)
    link
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all links", %{conn: conn} do
      conn = get(conn, Routes.link_path(conn, :index))
      assert json_response(conn, 200)["data"]
    end
  end

  describe "create link" do
    test "renders link when data is valid", %{conn: conn} do
      conn = post(conn, Routes.link_path(conn, :create), @create_attrs)
      assert %{"link" => link} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.link_path(conn, :show, link))

      assert %{
        "link" => link,
        "slug" => slug,
        "url" => url
      } = json_response(conn, 200)["data"]
    end
  end

  defp create_link(_) do
    link = fixture(:link)
    {:ok, link}
  end
end
