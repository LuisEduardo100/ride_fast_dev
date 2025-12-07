defmodule RideFast.Fleet.Vehicle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicles" do
    field :plate, :string
    field :model, :string
    field :color, :string
    field :seats, :integer
    field :active, :boolean, default: false
    field :driver_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(vehicle, attrs) do
    vehicle
    |> cast(attrs, [:plate, :model, :color, :seats, :active])
    |> validate_required([:plate, :model, :color, :seats, :active])
  end
end
