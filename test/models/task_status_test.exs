defmodule Shtask.TaskStatusTest do
  use Shtask.ModelCase
  import Shtask.Fixtures
  alias Shtask.TaskStatus

  @valid_attrs %{name: "In progress"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TaskStatus.changeset(%TaskStatus{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TaskStatus.changeset(%TaskStatus{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "task status can be added to the db" do
    changeset = TaskStatus.changeset(%TaskStatus{}, @valid_attrs)
    assert {:ok, _inserted_task_status} = Shtask.Repo.insert(changeset)
  end

  test "task status name should be present" do
    attrs = %{@valid_attrs | name: ""}
    changeset = TaskStatus.changeset(%TaskStatus{}, attrs)
    refute changeset.valid?

    attrs = %{@valid_attrs | name: nil}
    changeset = TaskStatus.changeset(%TaskStatus{}, attrs)
    refute changeset.valid?

    attrs = Map.delete(@valid_attrs, :name)
    changeset = TaskStatus.changeset(%TaskStatus{}, attrs)
    refute changeset.valid?
  end

  test "task status name should be unique" do
    task_status = fixture(:task_status)
    attrs = %{@valid_attrs | name: String.upcase(task_status.name)}
    changeset = TaskStatus.changeset(%TaskStatus{}, attrs)
    assert {:error, _inserted_task_status} = Shtask.Repo.insert(changeset)
  end

    test "task type preload function" do
    task_status = fixture(:task_status)
    task_status_preload = TaskStatus.preload(task_status.id)

    assert task_status.id == task_status_preload.id
  end
end
