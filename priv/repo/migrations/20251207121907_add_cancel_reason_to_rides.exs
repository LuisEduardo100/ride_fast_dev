defmodule RideFast.Repo.Migrations.AddCancelReasonToRides do
  use Ecto.Migration

  def change do
    alter table(:rides) do
      add :cancel_reason, :string
    end
  end
end
