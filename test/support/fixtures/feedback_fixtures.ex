defmodule RideFast.FeedbackFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RideFast.Feedback` context.
  """

  @doc """
  Generate a rating.
  """
  def rating_fixture(attrs \\ %{}) do
    {:ok, rating} =
      attrs
      |> Enum.into(%{
        comment: "some comment",
        score: 42
      })
      |> RideFast.Feedback.create_rating()

    rating
  end
end
