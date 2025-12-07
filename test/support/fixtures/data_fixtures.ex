defmodule RideFast.DataFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RideFast.Data` context.
  """

  @doc """
  Generate a language.
  """
  def language_fixture(attrs \\ %{}) do
    {:ok, language} =
      attrs
      |> Enum.into(%{
        code: "some code",
        name: "some name"
      })
      |> RideFast.Data.create_language()

    language
  end
end
