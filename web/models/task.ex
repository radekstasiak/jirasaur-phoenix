defmodule Shtask.Task do
  use Shtask.Web, :model
  import Ecto.Query
  schema "tasks" do
    field :name, :string
    belongs_to :task_type, Shtask.TaskType
    belongs_to :task_status, Shtask.TaskStatus
    has_many :user_tasks, Shtask.UserTask
    many_to_many :users, Shtask.User, join_through: Shtask.UserTask
    timestamps()
  end

  def preload(id) do
    task = Shtask.Task |> Shtask.Repo.get(id) |> Shtask.Repo.preload([:users])|> Shtask.Repo.preload([:task_type]) |> Shtask.Repo.preload([:task_status]) |> Shtask.Repo.preload([:user_tasks])
  end
  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    #IO.puts("#{params}")
    struct
    |> cast(params, [:name,:task_type_id,:task_status_id])
    |> downcase_value
    |> validate_required([:name,:task_type_id,:task_status_id])
    |> unique_constraint(:name)
    |> foreign_key_constraint(:task_type_id)
    |> foreign_key_constraint(:task_status_id)
  end


  def downcase_value(changeset) do
      
      update_change(changeset, :name, &String.downcase/1)
  end

end
