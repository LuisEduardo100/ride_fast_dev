defmodule RideFastWeb.RatingJSON do
  alias RideFast.Feedback.Rating

  @doc """
  Renders a list of ratings.
  """
  def index(%{ratings: ratings}) do
    %{data: for(rating <- ratings, do: data(rating))}
  end

  @doc """
  Renders a single rating.
  """
  def show(%{rating: rating}) do
    %{data: data(rating)}
  end

  defp data(%Rating{} = rating) do
    %{
      id: rating.id,
      score: rating.score,
      comment: rating.comment
    }
  end
end
