defmodule Jirasaur.Api.V1.ReportController do
	require Logger
  use Jirasaur.Web, :controller
  alias Jirasaur.User
  plug :setup_user
  def process_request(conn, params) do
  		IO.puts ("********")
  		user = conn.assigns[:user]
		json conn, "#{user.user_name}"  		
  end

  defp setup_user(conn, params) do
  	user_id = conn.params["user_id"]
  	user = Jirasaur.Repo.get_by(Jirasaur.User, user_id: user_id)
  	if (user == nil) do
  	 changeset = User.changeset(%User{}, conn.params)
  	 case Jirasaur.Repo.insert(changeset) do
      {:ok, inserted_user} ->
        user = inserted_user
        assign(conn, :user, user) 
      {:error, changeset} ->
        conn
      	|> put_status(:bad_request)
      	|> render(Jirasaur.ErrorView, "error.json", code: :bad_request)
      	|> halt()
     end
 	else 
 	 assign(conn, :user, user)
  	end
  end
 #TO-DO add tests for correct status codes, case insesitivity, user creation
end
