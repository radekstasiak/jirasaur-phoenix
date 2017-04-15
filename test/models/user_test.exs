defmodule Jirasaur.UserTest do
  use Jirasaur.ModelCase

  alias Jirasaur.User

  @valid_attrs %{team_domain: "some content", team_id: "some content", user_id: "some content", user_name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
