defmodule Jirasaur.Api.V1.ReportController do
	require Logger
  use Jirasaur.Web, :controller
  import Jirasaur.ErrorsHelper
  import Jirasaur.SuccessHelper
  alias Jirasaur.User
  alias Jirasaur.Task
  plug :setup_user
  plug :setup_task
  
  def process_request(conn, _params) do
      conn
      |> show_success      
  end

  defp setup_task(conn, params) do
    if(conn.params["text"] == nil) do
      show_bad_req(conn)
    else
      if(conn.params["text"] =~ "report" or conn.params["text"] == "" )do
        Jirasaur.ReportHelper.process_report(conn, params)  
      else
        Jirasaur.ReportHelper.process_cmd(conn, params)
      end
    end
  end


  defp setup_user(conn, _params) do
  	
    if(conn.params["user_id"] != nil) do
      user_id = String.downcase(conn.params["user_id"])
    	user = Jirasaur.Repo.get_by(Jirasaur.User, user_id: user_id)
    	if (user == nil) do
    	 changeset = User.changeset(%User{}, conn.params)
    	 case Jirasaur.Repo.insert(changeset) do
        {:ok, inserted_user} ->
          user = inserted_user
          assign(conn, :user, user) 
        {:error, _changeset} ->
          show_bad_req(conn)
       end
   	  else 
   	   assign(conn, :user, user)
    	end
    else
      show_bad_req(conn)
    end
  end
end
