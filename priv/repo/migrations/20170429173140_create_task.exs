defmodule Jirasaur.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string, null: false, unique: true
      add :tasktype_id, references(:tasktypes), null: false
      add :taskstatus_id, references(:taskstatuses), null: false
      timestamps()
    end

    create unique_index(:tasks, [:name])
  end
end
