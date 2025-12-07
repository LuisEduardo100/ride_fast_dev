defmodule RideFastWeb.RideControllerTest do
  use RideFastWeb.ConnCase

  import RideFast.OperationFixtures
  alias RideFast.Operation.Ride

  @create_attrs %{
    status: "some status",
    started_at: ~N[2025-12-05 22:59:00],
    origin_lat: 120.5,
    origin_lng: 120.5,
    dest_lat: 120.5,
    dest_lng: 120.5,
    price_estimate: "120.5",
    final_price: "120.5",
    requested_at: ~N[2025-12-05 22:59:00],
    ended_at: ~N[2025-12-05 22:59:00]
  }
  @update_attrs %{
    status: "some updated status",
    started_at: ~N[2025-12-06 22:59:00],
    origin_lat: 456.7,
    origin_lng: 456.7,
    dest_lat: 456.7,
    dest_lng: 456.7,
    price_estimate: "456.7",
    final_price: "456.7",
    requested_at: ~N[2025-12-06 22:59:00],
    ended_at: ~N[2025-12-06 22:59:00]
  }
  @invalid_attrs %{status: nil, started_at: nil, origin_lat: nil, origin_lng: nil, dest_lat: nil, dest_lng: nil, price_estimate: nil, final_price: nil, requested_at: nil, ended_at: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all rides", %{conn: conn} do
      conn = get(conn, ~p"/api/rides")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create ride" do
    test "renders ride when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/rides", ride: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/rides/#{id}")

      assert %{
               "id" => ^id,
               "dest_lat" => 120.5,
               "dest_lng" => 120.5,
               "ended_at" => "2025-12-05T22:59:00",
               "final_price" => "120.5",
               "origin_lat" => 120.5,
               "origin_lng" => 120.5,
               "price_estimate" => "120.5",
               "requested_at" => "2025-12-05T22:59:00",
               "started_at" => "2025-12-05T22:59:00",
               "status" => "some status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/rides", ride: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update ride" do
    setup [:create_ride]

    test "renders ride when data is valid", %{conn: conn, ride: %Ride{id: id} = ride} do
      conn = put(conn, ~p"/api/rides/#{ride}", ride: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/rides/#{id}")

      assert %{
               "id" => ^id,
               "dest_lat" => 456.7,
               "dest_lng" => 456.7,
               "ended_at" => "2025-12-06T22:59:00",
               "final_price" => "456.7",
               "origin_lat" => 456.7,
               "origin_lng" => 456.7,
               "price_estimate" => "456.7",
               "requested_at" => "2025-12-06T22:59:00",
               "started_at" => "2025-12-06T22:59:00",
               "status" => "some updated status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, ride: ride} do
      conn = put(conn, ~p"/api/rides/#{ride}", ride: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete ride" do
    setup [:create_ride]

    test "deletes chosen ride", %{conn: conn, ride: ride} do
      conn = delete(conn, ~p"/api/rides/#{ride}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/rides/#{ride}")
      end
    end
  end

  defp create_ride(_) do
    ride = ride_fixture()

    %{ride: ride}
  end
end
