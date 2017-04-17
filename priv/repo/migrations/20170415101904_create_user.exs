defmodule Jirasaur.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      #TODO add :citext for user_id
      add :user_id, :string, null: false, unique: true
      add :user_name, :string, null: false
      add :team_id, :string, null: false
      add :team_domain, :string, null: false

      timestamps()
    end

    create unique_index(:users, [:user_id])

  end
end
