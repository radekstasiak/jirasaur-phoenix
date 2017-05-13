defmodule Jirasaur.Fixtures do
  alias Jirasaur.User
  alias Jirasaur.Task
  alias Jirasaur.TaskStatus
  alias Jirasaur.TaskType
  alias Jirasaur.UserTask

  def fixture(type, assoc \\ [])

  def fixture(:user, assoc) do
    team_domain = assoc[:team_domain] || "XY1"
    team_id = assoc[:team_id] || "radev"
    user_id = assoc[:user_id] || "RS0"
    user_name = assoc[:user_name] || "Radek"
    attrs =  %{team_domain: team_domain, team_id: team_id, user_id: user_id, user_name: user_name}
    changeset = User.changeset(%User{}, attrs)
    case Jirasaur.Repo.insert(changeset) do
      {:ok, inserted_user} ->
          user = inserted_user
       end
  end
  def fixture(:task, assoc) do
    task_status = assoc[:task_status] || fixture(:task_status)
    task_type = assoc[:task_type] || fixture(:task_type)
    task_name = assoc[:task_name] || "JIRA-XXX"
    attrs =  %{name: task_name,task_status_id: task_status.id, task_type_id: task_type.id}
    changeset = Task.changeset(%Task{}, attrs)
    case Jirasaur.Repo.insert(changeset) do
      {:ok, inserted_task} ->
          task = inserted_task
    end
  end

  def fixture(:user_task, assoc) do
    task = assoc[:task] || fixture(:task)
    user = assoc[:user] || fixture(:user)
    user_task_started = assoc[:started] || DateTime.utc_now
    user_task_finished = assoc[:finished] || ""
    attrs =  %{started: user_task_started,finished: user_task_finished,task_id: task.id, user_id: user.id}
    changeset = UserTask.changeset(%UserTask{}, attrs)
    case Jirasaur.Repo.insert(changeset) do
      {:ok, inserted_user_task} ->
          user_task = inserted_user_task
    end
  end

  def fixture(:task_type, assoc) do
    name = assoc[:task_type_name] || "task"
    attrs =  %{name: name}
    changeset = TaskType.changeset(%TaskType{}, attrs)
    case Jirasaur.Repo.insert(changeset) do
      {:ok, inserted_task_type} ->
          task_type = inserted_task_type
       end
  end

    def fixture(:task_status, assoc) do
    name = assoc[:task_type_name] || "done"
    attrs =  %{name: name}
    changeset = TaskStatus.changeset(%TaskStatus{}, attrs)
    case Jirasaur.Repo.insert(changeset) do
      {:ok, inserted_task_status} ->
          task_type = inserted_task_status
    end
  end


end