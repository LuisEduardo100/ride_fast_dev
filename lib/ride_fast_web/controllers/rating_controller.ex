defmodule RideFastWeb.RatingController do
  use RideFastWeb, :controller

  alias RideFast.Feedback
  alias RideFast.Feedback.Rating
  alias RideFast.Operation

  action_fallback RideFastWeb.FallbackController

  def index(conn, _params) do
    ratings = Feedback.list_ratings()
    render(conn, :index, ratings: ratings)
  end

  def create(conn, %{"rating" => rating_params}) do
    # 1. Validar se a corrida existe e está FINALIZADA
    ride_id = rating_params["ride_id"]
    ride = Operation.get_ride!(ride_id)

    if ride.status != "FINALIZADA" do
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Você só pode avaliar corridas FINALIZADAS."})
    else
      # Se estiver ok, cria a avaliação
      with {:ok, %Rating{} = rating} <- Feedback.create_rating(rating_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/v1/ratings/#{rating}")
        |> render(:show, rating: rating)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    rating = Feedback.get_rating!(id)
    render(conn, :show, rating: rating)
  end

  def update(conn, %{"id" => id, "rating" => rating_params}) do
    rating = Feedback.get_rating!(id)

    with {:ok, %Rating{} = rating} <- Feedback.update_rating(rating, rating_params) do
      render(conn, :show, rating: rating)
    end
  end

  def delete(conn, %{"id" => id}) do
    rating = Feedback.get_rating!(id)

    with {:ok, %Rating{}} <- Feedback.delete_rating(rating) do
      send_resp(conn, :no_content, "")
    end
  end
end
