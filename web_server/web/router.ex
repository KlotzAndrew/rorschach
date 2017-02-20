defmodule WebServer.Router do
  use WebServer.Web, :router

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

  scope "/", WebServer do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", WebServer do
    pipe_through :api

    resources "/ticks", TickController, except: [:new, :edit]
    resources "/assets", AssetController, except: [:new, :edit]
    post "/assets/search", AssetController, :search
  end
end
