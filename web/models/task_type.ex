defmodule Jirasaur.TaskType do
  use Jirasaur.Web, :model

  schema "tasktypes" do
    field :name, :string
    has_many :tasks, Jirasaur.Task
    timestamps()
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
