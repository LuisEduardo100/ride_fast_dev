defmodule RideFast.Operation.Ride do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rides" do
    field :origin_lat, :float
    field :origin_lng, :float
    field :dest_lat, :float
    field :dest_lng, :float
    field :price_estimate, :decimal
    field :final_price, :decimal
    field :status, :string
    field :requested_at, :naive_datetime
    field :started_at, :naive_datetime
    field :cancel_reason, :string
    field :ended_at, :naive_datetime
    field :user_id, :id
    field :driver_id, :id
    field :vehicle_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ride, attrs) do
    ride
    |> cast(attrs, [
      :user_id,
      :driver_id,
      :vehicle_id,
      :origin_lat,
      :origin_lng,
      :dest_lat,
      :dest_lng,
      :price_estimate,
      :final_price,
      :status,
      :requested_at,
      :started_at,
      :ended_at,
      :cancel_reason
    ])
    |> validate_required([:user_id, :origin_lat, :origin_lng, :dest_lat, :dest_lng, :status])
  end
end
