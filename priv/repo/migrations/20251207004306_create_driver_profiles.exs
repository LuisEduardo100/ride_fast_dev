defmodule RideFast.Repo.Migrations.CreateDriverProfiles do
  use Ecto.Migration

  def change do
    create table(:driver_profiles) do
      add :license_number, :string
      add :license_expiry, :date
      add :background_check_ok, :boolean, default: false, null: false
      add :driver_id, references(:drivers, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:driver_profiles, [:driver_id])
  end
end
