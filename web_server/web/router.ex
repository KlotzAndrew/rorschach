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
    post "/asset_tracks/toggle", AssetTrackController, :toggle

    resources "/ticks", TickController, except: [:new, :edit]
    resources "/assets", AssetController, except: [:new, :edit]
    post "/assets/search", AssetController, :search
    post "/assets/start_tracking", AssetController, :start_tracking
    get "/trades/cash_holdings/:portfolio_id", TradeController, :cash_holdings
    get "/trades/stock_holdings/:portfolio_id", TradeController, :stock_holdings
    get "/trades/csv/:portfolio_id", TradeController, :csv
    get "/trade_signals/:portfolio_id", TradeSignalController, :index
  end
end
