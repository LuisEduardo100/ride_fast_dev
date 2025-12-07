defmodule RideFastWeb.DriverProfileJSON do
  alias RideFast.Accounts.DriverProfile

  @doc """
  Renders a list of driver_profiles.
  """
  def index(%{driver_profiles: driver_profiles}) do
    %{data: for(driver_profile <- driver_profiles, do: data(driver_profile))}
  end

  @doc """
  Renders a single driver_profile.
  """
  def show(%{driver_profile: driver_profile}) do
    %{data: data(driver_profile)}
  end

  defp data(%DriverProfile{} = driver_profile) do
    %{
      id: driver_profile.id,
      license_number: driver_profile.license_number,
      license_expiry: driver_profile.license_expiry,
      background_check_ok: driver_profile.background_check_ok
    }
  end
end
