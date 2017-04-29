defmodule Jirasaur.TaskTypeTest do
  use Jirasaur.ModelCase

  alias Jirasaur.TaskType

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TaskType.changeset(%TaskType{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TaskType.changeset(%TaskType{}, @invalid_attrs)
    refute changeset.valid?
  end
end
