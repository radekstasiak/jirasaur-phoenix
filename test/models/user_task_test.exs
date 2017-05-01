defmodule Jirasaur.UserTaskTest do
  use Jirasaur.ModelCase

  alias Jirasaur.UserTask

  @valid_attrs %{finished: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, started: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, task_id: 1 ,  user_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserTask.changeset(%UserTask{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserTask.changeset(%UserTask{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "task id should be valid" do
    attrs = %{@valid_attrs | task_id: ""}
    changeset = UserTask.changeset(%UserTask{}, attrs)
    refute changeset.valid?

    attrs = %{@valid_attrs | task_id: nil}
    changeset = UserTask.changeset(%UserTask{}, attrs)
    refute changeset.valid?

    attrs = Map.delete(@valid_attrs, :task_id)
    changeset = UserTask.changeset(%UserTask{}, attrs)
    refute changeset.valid?
  end

  test "user id should be present" do
    attrs = %{@valid_attrs | user_id: ""}
    changeset = UserTask.changeset(%UserTask{}, attrs)
    refute changeset.valid?

    attrs = %{@valid_attrs | user_id: nil}
    changeset = UserTask.changeset(%UserTask{}, attrs)
    refute changeset.valid?

    attrs = Map.delete(@valid_attrs, :user_id)
    changeset = UserTask.changeset(%UserTask{}, attrs)
    refute changeset.valid?
  end

  test "usertask started should be present" do
    attrs = %{@valid_attrs | started: ""}
    changeset = UserTask.changeset(%UserTask{}, attrs)
    refute changeset.valid?

    attrs = %{@valid_attrs | started: nil}
    changeset = UserTask.changeset(%UserTask{}, attrs)
    refute changeset.valid?

    attrs = Map.delete(@valid_attrs, :started)
    changeset = UserTask.changeset(%UserTask{}, attrs)
    refute changeset.valid?

  end


  test "usertask finished should be present" do
    attrs = %{@valid_attrs | finished: ""}
    changeset = UserTask.changeset(%UserTask{}, attrs)
    refute changeset.valid?

    attrs = %{@valid_attrs | finished: nil}
    changeset = UserTask.changeset(%UserTask{}, attrs)
    refute changeset.valid?

    attrs = Map.delete(@valid_attrs, :finished)
    changeset = UserTask.changeset(%UserTask{}, attrs)
    refute changeset.valid?
    
  end
end
