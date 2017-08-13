defmodule Shtask.TaskStatus do
  use Shtask.Web, :model

  schema "taskstatuses" do
    field :name, :string
    has_many :tasks, Shtask.Task
    timestamps()
  end

  def preload(id) do
    user = Shtask.TaskStatus |> Shtask.Repo.get(id)|> Shtask.Repo.preload([:tasks])
  end
  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> downcase_value
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def downcase_value(changeset) do
      update_change(changeset, :name, &String.downcase/1)
  end
end
