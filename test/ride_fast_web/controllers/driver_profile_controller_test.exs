defmodule RideFastWeb.DriverProfileControllerTest do
  use RideFastWeb.ConnCase

  import RideFast.AccountsFixtures
  alias RideFast.Accounts.DriverProfile

  @create_attrs %{
    license_number: "some license_number",
    license_expiry: ~D[2025-12-06],
    background_check_ok: true
  }
  @update_attrs %{
    license_number: "some updated license_number",
    license_expiry: ~D[2025-12-07],
    background_check_ok: false
  }
  @invalid_attrs %{license_number: nil, license_expiry: nil, background_check_ok: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all driver_profiles", %{conn: conn} do
      conn = get(conn, ~p"/api/driver_profiles")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create driver_profile" do
    test "renders driver_profile when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/driver_profiles", driver_profile: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/driver_profiles/#{id}")

      assert %{
               "id" => ^id,
               "background_check_ok" => true,
               "license_expiry" => "2025-12-06",
               "license_number" => "some license_number"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/driver_profiles", driver_profile: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update driver_profile" do
    setup [:create_driver_profile]

    test "renders driver_profile when data is valid", %{conn: conn, driver_profile: %DriverProfile{id: id} = driver_profile} do
      conn = put(conn, ~p"/api/driver_profiles/#{driver_profile}", driver_profile: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/driver_profiles/#{id}")

      assert %{
               "id" => ^id,
               "background_check_ok" => false,
               "license_expiry" => "2025-12-07",
               "license_number" => "some updated license_number"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, driver_profile: driver_profile} do
      conn = put(conn, ~p"/api/driver_profiles/#{driver_profile}", driver_profile: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete driver_profile" do
    setup [:create_driver_profile]

    test "deletes chosen driver_profile", %{conn: conn, driver_profile: driver_profile} do
      conn = delete(conn, ~p"/api/driver_profiles/#{driver_profile}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/driver_profiles/#{driver_profile}")
      end
    end
  end

  defp create_driver_profile(_) do
    driver_profile = driver_profile_fixture()

    %{driver_profile: driver_profile}
  end
end
