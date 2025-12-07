defmodule RideFastWeb.RatingControllerTest do
  use RideFastWeb.ConnCase

  import RideFast.FeedbackFixtures
  alias RideFast.Feedback.Rating

  @create_attrs %{
    comment: "some comment",
    score: 42
  }
  @update_attrs %{
    comment: "some updated comment",
    score: 43
  }
  @invalid_attrs %{comment: nil, score: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all ratings", %{conn: conn} do
      conn = get(conn, ~p"/api/ratings")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create rating" do
    test "renders rating when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/ratings", rating: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/ratings/#{id}")

      assert %{
               "id" => ^id,
               "comment" => "some comment",
               "score" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/ratings", rating: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update rating" do
    setup [:create_rating]

    test "renders rating when data is valid", %{conn: conn, rating: %Rating{id: id} = rating} do
      conn = put(conn, ~p"/api/ratings/#{rating}", rating: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/ratings/#{id}")

      assert %{
               "id" => ^id,
               "comment" => "some updated comment",
               "score" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, rating: rating} do
      conn = put(conn, ~p"/api/ratings/#{rating}", rating: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete rating" do
    setup [:create_rating]

    test "deletes chosen rating", %{conn: conn, rating: rating} do
      conn = delete(conn, ~p"/api/ratings/#{rating}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/ratings/#{rating}")
      end
    end
  end

  defp create_rating(_) do
    rating = rating_fixture()

    %{rating: rating}
  end
end
