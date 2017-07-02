defmodule Jirasaur.Api.V1.ReportController do
	require Logger
  use Jirasaur.Web, :controller
  import Jirasaur.ErrorsHelper
  alias Jirasaur.User
  alias Jirasaur.Task
  plug :setup_user
  plug :setup_task
  
  def process_request(conn, _params) do
  		user = conn.assigns[:user]
      task = conn.assigns[:task]
      user_task = conn.assigns[:user_task]
      #cmd = conn.assigns[:cmd]
		  #json conn, "#{user.user_name}:#{cmd}"

      cond do
        user_task == nil ->
         response_text = "user: #{user.user_name}\ntask: #{task.name}\ntask type: #{task.task_type.name}" 
        user_task != nil ->
         timeStart = Time.to_string(DateTime.to_time(user_task.started))
         cond do
           user_task.finished == nil ->
            timeFinish = ""
            user_task.finished != nil ->
            timeFinish = Time.to_string(DateTime.to_time(user_task.finished))
         end
         response_text = "user: #{user.user_name}\ntask: #{task.name}\ntask type: #{task.task_type.name}\nstarted: #{timeStart}\nfinished: #{timeFinish}" 
        
      end
      response = Poison.encode!(
                  %{
                    "response_type" => "in_channel",
                    "text" => "Saved!",
                    "attachments" => [%{
                      "text" => response_text
                    }]
                  }
                  )
      IO.puts response
      json conn, response
      
  end

  defp setup_task(conn, params) do
    if(conn.params["text"] == nil) do
      show_bad_req(conn)
    else
      Jirasaur.ReportHelper.process_cmd(conn, params)
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


  
 #TO-DO case insesitivity, user creation
end
