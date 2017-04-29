defmodule Jirasaur.UserTaskTest do
  use Jirasaur.ModelCase

  alias Jirasaur.UserTask

  @valid_attrs %{finished: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, started: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserTask.changeset(%UserTask{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserTask.changeset(%UserTask{}, @invalid_attrs)
    refute changeset.valid?
  end
end
