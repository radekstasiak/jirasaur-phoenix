defmodule Jirasaur.User do
  use Jirasaur.Web, :model

  schema "users" do
    field :user_id, :string
    field :user_name, :string
    field :team_id, :string
    field :team_domain, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :user_name, :team_id, :team_domain])
    |> validate_required([:user_id, :user_name, :team_id, :team_domain])
  end
end
