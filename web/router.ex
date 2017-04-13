defmodule Jirasaur.Router do
  use Jirasaur.Web, :router

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

  pipeline :authenticated do
    plug Jirasaur.Plug.Authenticate
  end

  scope "/", Jirasaur do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Jirasaur.Api, as: :api do
    pipe_through [:api,:authenticated]

    scope "/v1", V1, as: :v1 do
      
      post "/report", ReportController, :process_request
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Jirasaur do
  #   pipe_through :api
  # end
end
