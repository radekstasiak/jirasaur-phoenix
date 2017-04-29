defmodule Jirasaur.TaskStatusTest do
  use Jirasaur.ModelCase

  alias Jirasaur.TaskStatus

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TaskStatus.changeset(%TaskStatus{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TaskStatus.changeset(%TaskStatus{}, @invalid_attrs)
    refute changeset.valid?
  end
end
