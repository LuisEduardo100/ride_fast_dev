defmodule RideFast.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RideFast.Accounts` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        name: "some name",
        password_hash: "some password_hash",
        phone: "some phone",
        role: "some role"
      })
      |> RideFast.Accounts.create_user()

    user
  end

  @doc """
  Generate a driver.
  """
  def driver_fixture(attrs \\ %{}) do
    {:ok, driver} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name",
        password_hash: "some password_hash",
        phone: "some phone",
        status: "some status"
      })
      |> RideFast.Accounts.create_driver()

    driver
  end
end
