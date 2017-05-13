defmodule Jirasaur.Repo.Migrations.UpdateUserTaskTable do
  use Ecto.Migration

  def change do
  	alter table(:usertasks) do
  		modify :finished, :utc_datetime, null: true
  	end
  end
end
