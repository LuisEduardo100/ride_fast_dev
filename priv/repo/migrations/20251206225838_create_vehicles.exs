defmodule RideFast.Repo.Migrations.CreateVehicles do
  use Ecto.Migration

  def change do
    create table(:vehicles) do
      add :plate, :string
      add :model, :string
      add :color, :string
      add :seats, :integer
      add :active, :boolean, default: false, null: false
      add :driver_id, references(:drivers, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:vehicles, [:driver_id])
  end
end
