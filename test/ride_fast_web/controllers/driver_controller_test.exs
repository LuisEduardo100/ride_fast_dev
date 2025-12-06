defmodule RideFastWeb.DriverControllerTest do
  use RideFastWeb.ConnCase

  import RideFast.AccountsFixtures
  alias RideFast.Accounts.Driver

  @create_attrs %{
    name: "some name",
    status: "some status",
    email: "some email",
    phone: "some phone",
    password_hash: "some password_hash"
  }
  @update_attrs %{
    name: "some updated name",
    status: "some updated status",
    email: "some updated email",
    phone: "some updated phone",
    password_hash: "some updated password_hash"
  }
  @invalid_attrs %{name: nil, status: nil, email: nil, phone: nil, password_hash: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all drivers", %{conn: conn} do
      conn = get(conn, ~p"/api/drivers")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create driver" do
    test "renders driver when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/drivers", driver: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/drivers/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some email",
               "name" => "some name",
               "password_hash" => "some password_hash",
               "phone" => "some phone",
               "status" => "some status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/drivers", driver: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update driver" do
    setup [:create_driver]

    test "renders driver when data is valid", %{conn: conn, driver: %Driver{id: id} = driver} do
      conn = put(conn, ~p"/api/drivers/#{driver}", driver: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/drivers/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some updated email",
               "name" => "some updated name",
               "password_hash" => "some updated password_hash",
               "phone" => "some updated phone",
               "status" => "some updated status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, driver: driver} do
      conn = put(conn, ~p"/api/drivers/#{driver}", driver: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete driver" do
    setup [:create_driver]

    test "deletes chosen driver", %{conn: conn, driver: driver} do
      conn = delete(conn, ~p"/api/drivers/#{driver}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/drivers/#{driver}")
      end
    end
  end

  defp create_driver(_) do
    driver = driver_fixture()

    %{driver: driver}
  end
end
