defmodule Shtask.Router do
  use Shtask.Web, :router

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
    plug Shtask.Plug.Authenticate
  end

  scope "/", Shtask do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/", Shtask do
    pipe_through [:browser,:authenticated]
    resources "/users", UserController
  end

  scope "/api", Shtask.Api, as: :api do
    pipe_through [:api,:authenticated]
    scope "/v1", V1, as: :v1 do
      post "/report", ReportController, :process_request
    end
  end



  # Other scopes may use custom stacks.
  # scope "/api", Shtask do
  #   pipe_through :api
  # end
end
