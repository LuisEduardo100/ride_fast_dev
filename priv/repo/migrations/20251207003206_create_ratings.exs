defmodule RideFast.Repo.Migrations.CreateRatings do
  use Ecto.Migration

  def change do
    create table(:ratings) do
      add :score, :integer
      add :comment, :string
      add :ride_id, references(:rides, on_delete: :nothing)
      add :from_user_id, references(:users, on_delete: :nothing)
      add :to_driver_id, references(:drivers, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:ratings, [:ride_id])
    create index(:ratings, [:from_user_id])
    create index(:ratings, [:to_driver_id])
  end
end
