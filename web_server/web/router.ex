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
    plug :accepts, ["json-api"]
  end

  scope "/", WebServer do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", WebServer do
    pipe_through :api

    resources "/trades", TradeController, except: [:new, :edit]
    resources "/portfolios", PortfolioController, except: [:new, :edit]
    resources "/asset_tracks", AssetTrackController, except: [:new, :edit]
    resources "/ticks", TickController, except: [:new, :edit]
    resources "/assets", AssetController, except: [:new, :edit]
    post "/assets/search", AssetController, :search
    get "/trades/cash_sums/:portfolio_id", TradeController, :cash_sums
    get "/trades/stock_sums/:portfolio_id", TradeController, :stock_sums
  end
end
