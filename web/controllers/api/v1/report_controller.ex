defmodule Jirasaur.Api.V1.ReportController do
	require Logger
  use Jirasaur.Web, :controller
  
  def process_request(conn, params) do
		json conn, "#{conn.status}"  		
  end
end
