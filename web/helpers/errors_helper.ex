defmodule Jirasaur.ErrorsHelper do
  
  def show_bad_req(conn,assoc \\ []) do
  msg = assoc[:msg] || :bad_request
   conn
   |> Plug.Conn.put_status(:bad_request)
   |> Phoenix.Controller.render(Jirasaur.Api.V1.ReportView,"error.v1.json", code: msg)
   |> Plug.Conn.halt()
  end

  def show_unauthorized(conn) do
  	  conn
   |> Plug.Conn.put_status(:unauthorized)
   |> Phoenix.Controller.render(Jirasaur.Api.V1.ReportView,"error.v1.json", code: :unauthorized)
   |> Plug.Conn.halt()

  end

end
