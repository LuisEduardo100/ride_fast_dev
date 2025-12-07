defmodule RideFast.OperationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RideFast.Operation` context.
  """

  @doc """
  Generate a ride.
  """
  def ride_fixture(attrs \\ %{}) do
    {:ok, ride} =
      attrs
      |> Enum.into(%{
        dest_lat: 120.5,
        dest_lng: 120.5,
        ended_at: ~N[2025-12-05 22:59:00],
        final_price: "120.5",
        origin_lat: 120.5,
        origin_lng: 120.5,
        price_estimate: "120.5",
        requested_at: ~N[2025-12-05 22:59:00],
        started_at: ~N[2025-12-05 22:59:00],
        status: "some status"
      })
      |> RideFast.Operation.create_ride()

    ride
  end
end
