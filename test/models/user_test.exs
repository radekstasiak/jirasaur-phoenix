defmodule Jirasaur.UserTest do
  use Jirasaur.ModelCase

  alias Jirasaur.User

  @valid_attrs %{team_domain: "XY1", team_id: "radev", user_id: "RS1", user_name: "Radek"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "user name should be present" do
    attrs = %{@valid_attrs | user_name: ""}
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?

    attrs = %{@valid_attrs | user_name: nil}
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?

    attrs = Map.delete(@valid_attrs, :user_name)
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?

  end

  test "user id should be present" do
    attrs = %{@valid_attrs | user_id: ""}
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?

    attrs = %{@valid_attrs | user_id: nil}
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?

    attrs = Map.delete(@valid_attrs, :user_id)
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?
  end

  test "user id should be unique" do
    changeset = User.changeset(%User{}, @valid_attrs)
    {:ok, _inserted_user} = Jirasaur.Repo.insert(changeset)
    assert {:error, _changeset} = Jirasaur.Repo.insert(changeset)
  end

  test "team id should be present" do
    attrs = %{@valid_attrs | team_domain: ""}
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?

    attrs = %{@valid_attrs | team_domain: nil}
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?

    attrs = Map.delete(@valid_attrs, :team_domain)
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?
  end

  test "team domain should be present" do
    attrs = %{@valid_attrs | team_domain: ""}
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?

    attrs = %{@valid_attrs | team_domain: nil}
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?

    attrs = Map.delete(@valid_attrs, :team_domain)
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?
  end


  test "team id should not be unique" do
    changeset = User.changeset(%User{}, @valid_attrs)
    {:ok, _inserted_user} = Jirasaur.Repo.insert(changeset)
    attrs = %{@valid_attrs | user_id: "AB1"}
    changeset = User.changeset(%User{}, attrs)
    assert {:ok, _inserted_user} = Jirasaur.Repo.insert(changeset)
  end


  test "user_id field is case insensitive" do
    changeset = User.changeset(%User{}, @valid_attrs)
    {:ok, _inserted_user} = Jirasaur.Repo.insert(changeset)
    attrs = %{@valid_attrs | user_id: "rs1"}
    changeset = User.changeset(%User{}, attrs)
    assert {:error, _changeset} = Jirasaur.Repo.insert(changeset)
  end

end
