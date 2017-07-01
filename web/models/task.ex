defmodule Jirasaur.Task do
  use Jirasaur.Web, :model
  import Ecto.Query
  schema "tasks" do
    field :name, :string
    belongs_to :task_type, Jirasaur.TaskType
    belongs_to :task_status, Jirasaur.TaskStatus
    has_many :user_tasks, Jirasaur.UserTask
    many_to_many :users, Jirasaur.User, join_through: Jirasaur.UserTask
    timestamps()
  end

  def preload(id) do
    task = Jirasaur.Task |> Jirasaur.Repo.get(id) |> Jirasaur.Repo.preload([:users])|> Jirasaur.Repo.preload([:task_type]) |> Jirasaur.Repo.preload([:task_status]) |> Jirasaur.Repo.preload([:user_tasks])
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
