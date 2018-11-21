defmodule SamlinksWeb.Router do
  use SamlinksWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SamlinksWeb do
    pipe_through :browser

    get "/", LinkController, :index
    # get "/stats", LinkController, :show_stats
    get "/:slug", LinkController, :show
  end

  scope "/api", SamlinksWeb do
    pipe_through :api

    post "/", LinkController, :create
  end
end
