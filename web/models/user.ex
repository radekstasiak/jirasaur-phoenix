defmodule Shtask.User do
  use Shtask.Web, :model

  schema "users" do
    field :user_id, :string
    field :user_name, :string
    field :team_id, :string
    field :team_domain, :string
    has_many :user_tasks, Shtask.UserTask
    many_to_many :tasks, Shtask.Task, join_through: Shtask.UserTask
    timestamps()
  end

  def preload(id) do
    user = Shtask.User |> Shtask.Repo.get(id)|> Shtask.Repo.preload([:tasks]) |> Shtask.Repo.preload([:user_tasks])
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
