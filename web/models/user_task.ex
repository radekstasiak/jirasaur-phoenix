defmodule Jirasaur.UserTask do
  use Jirasaur.Web, :model

  schema "usertasks" do
    field :started, Ecto.DateTime
    field :finished, Ecto.DateTime
    belongs_to :task, Jirasaur.Task
    belongs_to :user, Jirasaur.User
    timestamps()
  end

  def preload(id) do
    user_task = Jirasaur.UserTask |> Jirasaur.Repo.get(id)|> Jirasaur.Repo.preload([:task]) |> Jirasaur.Repo.preload([:user])
  end
  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:started, :finished,:task_id,:user_id])
    |> validate_required([:started,:task_id,:user_id])
    |> foreign_key_constraint(:task_id)
    |> foreign_key_constraint(:user_id)
  end
end
