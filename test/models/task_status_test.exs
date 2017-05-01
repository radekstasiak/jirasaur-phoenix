defmodule Jirasaur.TaskStatusTest do
  use Jirasaur.ModelCase
  import Jirasaur.Fixtures
  alias Jirasaur.TaskStatus

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
    assert {:ok, _inserted_task_status} = Jirasaur.Repo.insert(changeset)
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
    assert {:error, _inserted_task_status} = Jirasaur.Repo.insert(changeset)
  end
end
