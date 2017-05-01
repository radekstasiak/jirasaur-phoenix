defmodule Jirasaur.Task do
  use Jirasaur.Web, :model

  schema "tasks" do
    field :name, :string
    belongs_to :task_type, Jirasaur.TaskType
    belongs_to :task_status, Jirasaur.TaskStatus
    has_many :user_tasks, Jirasaur.UserTask
    many_to_many :users, Jirasaur.User, join_through: Jirasaur.UserTask
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
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
