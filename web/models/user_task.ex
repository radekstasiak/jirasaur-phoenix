defmodule Shtask.UserTask do
  use Shtask.Web, :model

  schema "usertasks" do
    field :started, Timex.Ecto.DateTime
    field :finished, Timex.Ecto.DateTime
    belongs_to :task, Shtask.Task
    belongs_to :user, Shtask.User
    timestamps()
  end

  def preload(id) do
    user_task = Shtask.UserTask |> Shtask.Repo.get(id)|> Shtask.Repo.preload([:task]) |> Shtask.Repo.preload([:user])
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
