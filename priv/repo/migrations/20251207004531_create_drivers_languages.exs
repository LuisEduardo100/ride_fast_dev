defmodule RideFast.Repo.Migrations.CreateDriversLanguages do
  use Ecto.Migration

  def change do
    create table(:drivers_languages, primary_key: false) do
      add :driver_id, references(:drivers, on_delete: :delete_all), primary_key: true
      add :language_id, references(:languages, on_delete: :delete_all), primary_key: true
    end

    create index(:drivers_languages, [:driver_id])
    create index(:drivers_languages, [:language_id])
    create unique_index(:drivers_languages, [:driver_id, :language_id])
  end
end
