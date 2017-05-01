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

  def fixture(type, assoc \\ [])
  def fixture(:task, assoc) do
    task_status = assoc[:task_status] || fixture(:task_status)
    task_type = assoc[:task_type] || fixture(:task_type)
    attrs =  %{name: "JIRA-XXX",task_status_id: task_status.id,task_type_id: task_type.id}
    changeset = Task.changeset(%Task{}, attrs)
    case Jirasaur.Repo.insert(changeset) do
      {:ok, inserted_task} ->
          task = inserted_task
    end
  end

  def fixture(:user_tass, assoc) do
    task = assoc[:task] || fixture(:task)
    user = assoc[:user] || fixture(:user)
    attrs =  %{started: DateTime.utc_now,finished: DateTime.utc_now,task_id: task.id, user: user.id}
    changeset = UserTask.changeset(%UserTask{}, attrs)
    case Jirasaur.Repo.insert(changeset) do
      {:ok, inserted_user_task} ->
          user_task = inserted_user_task
    end
  end


end