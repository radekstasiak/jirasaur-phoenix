defmodule Jirasaur.Repo.Migrations.CreateTaskStatus do
  use Ecto.Migration

  def change do
    create table(:taskstatuses) do
      add :name, :string, null: false, unique: true

      timestamps()
    end
    create unique_index(:taskstatuses, [:name])
  end
end
