defmodule RideFastWeb.DriverProfileController do
  use RideFastWeb, :controller

  alias RideFast.Accounts
  alias RideFast.Accounts.DriverProfile

  action_fallback RideFastWeb.FallbackController

  def show(conn, %{"driver_id" => driver_id}) do
    # Busca o perfil pelo ID do motorista
    profile = Accounts.get_driver_profile_by_driver!(driver_id)
    render(conn, :show, driver_profile: profile)
  end

  def create(conn, %{"driver_id" => driver_id, "driver_profile" => profile_params}) do
    # Força o ID do motorista nos parâmetros
    params = Map.put(profile_params, "driver_id", driver_id)

    with {:ok, %DriverProfile{} = driver_profile} <- Accounts.create_driver_profile(params) do
      conn
      |> put_status(:created)
      |> render(:show, driver_profile: driver_profile)
    end
  end

  def update(conn, %{"driver_id" => driver_id, "driver_profile" => profile_params}) do
    driver_profile = Accounts.get_driver_profile_by_driver!(driver_id)

    with {:ok, %DriverProfile{} = driver_profile} <-
           Accounts.update_driver_profile(driver_profile, profile_params) do
      render(conn, :show, driver_profile: driver_profile)
    end
  end
end
