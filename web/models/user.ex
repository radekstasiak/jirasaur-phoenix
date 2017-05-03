defmodule Jirasaur.User do
  use Jirasaur.Web, :model

  schema "users" do
    field :user_id, :string
    field :user_name, :string
    field :team_id, :string
    field :team_domain, :string
    has_many :user_tasks, Jirasaur.UserTask
    many_to_many :tasks, Jirasaur.Task, join_through: Jirasaur.UserTask
    timestamps()
  end

  def preload(id) do
    user = Jirasaur.User |> Jirasaur.Repo.get(id)|> Jirasaur.Repo.preload([:tasks]) |> Jirasaur.Repo.preload([:user_tasks])
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :user_name, :team_id, :team_domain])
    |> downcase_value
    |> validate_required([:user_id, :user_name, :team_id, :team_domain])
    |> unique_constraint(:user_id)
  end

  def downcase_value(changeset) do
      update_change(changeset, :user_id, &String.downcase/1)
  end
end
