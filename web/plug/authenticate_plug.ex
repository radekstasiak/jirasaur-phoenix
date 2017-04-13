defmodule Jirasaur.Plug.Authenticate do
  @behaviour Plug
  import Plug.Conn
  #import Phoenix.Controller, only: [redirect: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    slack_token = System.get_env("SLACK_TOKEN")
    if (slack_token ==nil || slack_token != conn.params["token"]) do  
      conn
      |> put_status(:unauthorized)
      |> Phoenix.Controller.render(Jirasaur.ErrorView, "error.json", code: :unauthorized)
      |> halt()
    else
      conn
      #|> put_status(:unauthorized)
      #Phoenix.Controller.redirect(conn,to: Jirasaur.Router.Helpers.api_v1_error_path(conn,:show))


    end
  end
end