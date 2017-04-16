defmodule Jirasaur.Api.V1.ReportController do
	require Logger
  use Jirasaur.Web, :controller
  alias Jirasaur.User
  plug :setup_user
  
  def process_request(conn, _params) do
  		IO.puts ("********")
  		user = conn.assigns[:user]
		json conn, "#{user.user_name}"  		
  end

  defp setup_user(conn, _params) do
  	user_id = conn.params["user_id"]
    if(user_id != nil) do
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

  def show_bad_req(conn) do
   conn
   |> put_status(:bad_request)
   |> render(Jirasaur.ErrorView, "error.json", code: :bad_request)
   |> halt()
  end
 #TO-DO case insesitivity, user creation
end
