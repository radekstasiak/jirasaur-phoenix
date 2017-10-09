defmodule Shtask.Repo.Migrations.CreateUserTask do
  use Ecto.Migration

  def change do
    create table(:usertasks) do
      add :started, :timestamptz, null: false
      add :finished, :timestamptz, null: false
      add :user_id, references(:users), null: false
      add :task_id, references(:tasks), null: false
      timestamps(type: :timestamptz)
    end

  end
end
