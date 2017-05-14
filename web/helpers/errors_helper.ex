defmodule Jirasaur.ErrorsHelper do
  
  def show_bad_req(conn,assoc \\ []) do
  msg = assoc[:msg] || :bad_request
   conn
   |> Plug.Conn.put_status(:bad_request)
   |> Phoenix.Controller.render(Jirasaur.ErrorView, "error.json", code: msg)
   |> Plug.Conn.halt()
  end

end
