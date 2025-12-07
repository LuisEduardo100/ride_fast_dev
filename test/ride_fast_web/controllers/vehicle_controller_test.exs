defmodule RideFastWeb.VehicleControllerTest do
  use RideFastWeb.ConnCase

  import RideFast.FleetFixtures
  alias RideFast.Fleet.Vehicle

  @create_attrs %{
    active: true,
    color: "some color",
    plate: "some plate",
    model: "some model",
    seats: 42
  }
  @update_attrs %{
    active: false,
    color: "some updated color",
    plate: "some updated plate",
    model: "some updated model",
    seats: 43
  }
  @invalid_attrs %{active: nil, color: nil, plate: nil, model: nil, seats: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all vehicles", %{conn: conn} do
      conn = get(conn, ~p"/api/vehicles")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create vehicle" do
    test "renders vehicle when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/vehicles", vehicle: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/vehicles/#{id}")

      assert %{
               "id" => ^id,
               "active" => true,
               "color" => "some color",
               "model" => "some model",
               "plate" => "some plate",
               "seats" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/vehicles", vehicle: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update vehicle" do
    setup [:create_vehicle]

    test "renders vehicle when data is valid", %{conn: conn, vehicle: %Vehicle{id: id} = vehicle} do
      conn = put(conn, ~p"/api/vehicles/#{vehicle}", vehicle: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/vehicles/#{id}")

      assert %{
               "id" => ^id,
               "active" => false,
               "color" => "some updated color",
               "model" => "some updated model",
               "plate" => "some updated plate",
               "seats" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, vehicle: vehicle} do
      conn = put(conn, ~p"/api/vehicles/#{vehicle}", vehicle: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete vehicle" do
    setup [:create_vehicle]

    test "deletes chosen vehicle", %{conn: conn, vehicle: vehicle} do
      conn = delete(conn, ~p"/api/vehicles/#{vehicle}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/vehicles/#{vehicle}")
      end
    end
  end

  defp create_vehicle(_) do
    vehicle = vehicle_fixture()

    %{vehicle: vehicle}
  end
end
