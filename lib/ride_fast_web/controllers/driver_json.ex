defmodule RideFastWeb.DriverJSON do
  alias RideFast.Accounts.Driver

  @doc """
  Renders a list of drivers.
  """
  def index(%{drivers: drivers}) do
    %{data: for(driver <- drivers, do: data(driver))}
  end

  @doc """
  Renders a single driver.
  """
  def show(%{driver: driver}) do
    %{data: data(driver)}
  end

  defp data(%Driver{} = driver) do
    %{
      id: driver.id,
      name: driver.name,
      email: driver.email,
      phone: driver.phone,
      password_hash: driver.password_hash,
      status: driver.status
    }
  end
end
