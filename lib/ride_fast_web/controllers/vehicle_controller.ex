defmodule RideFastWeb.VehicleController do
  use RideFastWeb, :controller

  alias RideFast.Fleet
  alias RideFast.Fleet.Vehicle

  action_fallback RideFastWeb.FallbackController

  def index(conn, _params) do
    vehicles = Fleet.list_vehicles()
    render(conn, :index, vehicles: vehicles)
  end

  def create(conn, %{"vehicle" => vehicle_params} = params) do
    with {:ok, %Vehicle{} = vehicle} <- Fleet.create_vehicle(vehicle_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/vehicles/#{vehicle}")
      |> render(:show, vehicle: vehicle)
    end
  end

  def show(conn, %{"id" => id}) do
    vehicle = Fleet.get_vehicle!(id)
    render(conn, :show, vehicle: vehicle)
  end

  def update(conn, %{"id" => id, "vehicle" => vehicle_params} = params) do
    vehicle = Fleet.get_vehicle!(id)

    with {:ok, %Vehicle{} = vehicle} <- Fleet.update_vehicle(vehicle, vehicle_params) do
      render(conn, :show, vehicle: vehicle)
    end
  end

  def delete(conn, %{"id" => id}) do
    vehicle = Fleet.get_vehicle!(id)

    with {:ok, %Vehicle{}} <- Fleet.delete_vehicle(vehicle) do
      send_resp(conn, :no_content, "")
    end
  end
end
