defmodule Jirasaur.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :user_id, :string
      add :user_name, :string
      add :team_id, :string
      add :team_domain, :string

      timestamps()
    end

  end
end
