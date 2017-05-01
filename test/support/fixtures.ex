defmodule Jirasaur.Fixtures do
  alias Jirasaur.User
  alias Jirasaur.Task
  alias Jirasaur.TaskStatus
  alias Jirasaur.TaskType
  alias Jirasaur.UserTask

  def fixture(:user) do
  	attrs =  %{team_domain: "XY1", team_id: "radev", user_id: "RS0", user_name: "Radek"}
  	changeset = User.changeset(%User{}, attrs)
  	case Jirasaur.Repo.insert(changeset) do
    	{:ok, inserted_user} ->
          user = inserted_user
       end
  end
end