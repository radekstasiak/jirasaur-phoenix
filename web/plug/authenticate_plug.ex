defmodule Shtask.Plug.Authenticate do
  @behaviour Plug
  import Plug.Conn
  import Shtask.ErrorsHelper
  import Phoenix.Controller, only: [render: 4]

  def init(opts), do: opts

  def call(conn, _opts) do
    slack_token = System.get_env("SLACK_TOKEN")
    if (slack_token ==nil || slack_token != conn.params["token"]) do  
      show_unauthorized(conn)
    else
      conn
    end
  end
end
