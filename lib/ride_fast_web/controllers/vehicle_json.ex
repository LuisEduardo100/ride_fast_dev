defmodule RideFastWeb.VehicleJSON do
  alias RideFast.Fleet.Vehicle

  @doc """
  Renders a list of vehicles.
  """
  def index(%{vehicles: vehicles}) do
    %{data: for(vehicle <- vehicles, do: data(vehicle))}
  end

  @doc """
  Renders a single vehicle.
  """
  def show(%{vehicle: vehicle}) do
    %{data: data(vehicle)}
  end

  defp data(%Vehicle{} = vehicle) do
    %{
      id: vehicle.id,
      plate: vehicle.plate,
      model: vehicle.model,
      color: vehicle.color,
      seats: vehicle.seats,
      active: vehicle.active
    }
  end
end
