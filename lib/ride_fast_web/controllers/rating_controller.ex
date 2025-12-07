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

  def create(conn, params) do
    ride_id = params["ride_id"]
    ride = Operation.get_ride!(ride_id)

    if ride.status != "FINALIZADA" do
      conn |> put_status(:forbidden) |> json(%{error: "Ride not finished"})
    else
      with {:ok, %Rating{} = rating} <- Feedback.create_rating(params) do
        conn
        |> put_status(:created)
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

  def index_by_ride(conn, %{"ride_id" => ride_id}) do
    id_int = String.to_integer(ride_id)

    ratings = Feedback.list_ratings_by_ride(id_int)
    render(conn, :index, ratings: ratings)
  end

  def index_by_driver(conn, %{"driver_id" => driver_id}) do
    id_int = String.to_integer(driver_id)

    ratings = Feedback.list_ratings_by_driver(id_int)
    render(conn, :index, ratings: ratings)
  end

  def index_by_user(conn, %{"user_id" => user_id}) do
    id_int = String.to_integer(user_id)
    ratings = Feedback.list_ratings_by_user(id_int)
    render(conn, :index, ratings: ratings)
  end
end
