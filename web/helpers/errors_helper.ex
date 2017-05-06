defmodule Jirasaur.ErrorsHelper do
  
  def show_bad_req(conn) do
   conn
   |> Plug.Conn.put_status(:bad_request)
   |> Phoenix.Controller.render(Jirasaur.ErrorView, "error.json", code: :bad_request)
   |> Plug.Conn.halt()
  end

end
