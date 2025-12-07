defmodule RideFastWeb.RideJSON do
  alias RideFast.Operation.Ride

  @doc """
  Renders a list of rides.
  """
  def index(%{rides: rides}) do
    %{data: for(ride <- rides, do: data(ride))}
  end

  @doc """
  Renders a single ride.
  """
  def show(%{ride: ride}) do
    %{data: data(ride)}
  end

  defp data(%Ride{} = ride) do
    %{
      id: ride.id,
      origin_lat: ride.origin_lat,
      origin_lng: ride.origin_lng,
      dest_lat: ride.dest_lat,
      dest_lng: ride.dest_lng,
      price_estimate: ride.price_estimate,
      final_price: ride.final_price,
      status: ride.status,
      requested_at: ride.requested_at,
      started_at: ride.started_at,
      ended_at: ride.ended_at
    }
  end
end
