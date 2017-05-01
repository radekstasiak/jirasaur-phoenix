defmodule Jirasaur.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string, null: false, unique: true
      add :task_type_id, references(:tasktypes), null: false
      add :task_status_id, references(:taskstatuses), null: false
      timestamps()
    end

    create unique_index(:tasks, [:name])
  end
end
