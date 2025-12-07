defmodule RideFast.Repo.Migrations.CreateLanguages do
  use Ecto.Migration

  def change do
    create table(:languages) do
      add :code, :string
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
