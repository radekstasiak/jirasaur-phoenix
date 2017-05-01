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

  def fixture(:task_type) do
    attrs =  %{name: "task"}
    changeset = TaskType.changeset(%TaskType{}, attrs)
    case Jirasaur.Repo.insert(changeset) do
      {:ok, inserted_task_type} ->
          task_type = inserted_task_type
       end
  end

    def fixture(:task_status) do
    attrs =  %{name: "done"}
    changeset = TaskStatus.changeset(%TaskStatus{}, attrs)
    case Jirasaur.Repo.insert(changeset) do
      {:ok, inserted_task_status} ->
          task_type = inserted_task_status
       end
  end


end