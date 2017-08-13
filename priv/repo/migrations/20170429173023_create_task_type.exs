defmodule Shtask.Repo.Migrations.CreateTaskType do
  use Ecto.Migration

  def change do
    create table(:tasktypes) do
      add :name, :string, null: false, unique: true

      timestamps()
    end

    create unique_index(:tasktypes, [:name])
  end
end
