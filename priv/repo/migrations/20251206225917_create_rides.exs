defmodule RideFast.Repo.Migrations.CreateRides do
  use Ecto.Migration

  def change do
    create table(:rides) do
      add :origin_lat, :float
      add :origin_lng, :float
      add :dest_lat, :float
      add :dest_lng, :float
      add :price_estimate, :decimal
      add :final_price, :decimal
      add :status, :string
      add :requested_at, :naive_datetime
      add :started_at, :naive_datetime
      add :ended_at, :naive_datetime
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :driver_id, references(:drivers, on_delete: :nothing), null: true
      add :vehicle_id, references(:vehicles, on_delete: :nothing), null: true

      timestamps(type: :utc_datetime)
    end

    create index(:rides, [:user_id])
    create index(:rides, [:driver_id])
    create index(:rides, [:vehicle_id])
  end
end
