defmodule RideFastWeb.LanguageControllerTest do
  use RideFastWeb.ConnCase

  import RideFast.DataFixtures
  alias RideFast.Data.Language

  @create_attrs %{
    code: "some code",
    name: "some name"
  }
  @update_attrs %{
    code: "some updated code",
    name: "some updated name"
  }
  @invalid_attrs %{code: nil, name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all languages", %{conn: conn} do
      conn = get(conn, ~p"/api/languages")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create language" do
    test "renders language when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/languages", language: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/languages/#{id}")

      assert %{
               "id" => ^id,
               "code" => "some code",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/languages", language: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update language" do
    setup [:create_language]

    test "renders language when data is valid", %{conn: conn, language: %Language{id: id} = language} do
      conn = put(conn, ~p"/api/languages/#{language}", language: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/languages/#{id}")

      assert %{
               "id" => ^id,
               "code" => "some updated code",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, language: language} do
      conn = put(conn, ~p"/api/languages/#{language}", language: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete language" do
    setup [:create_language]

    test "deletes chosen language", %{conn: conn, language: language} do
      conn = delete(conn, ~p"/api/languages/#{language}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/languages/#{language}")
      end
    end
  end

  defp create_language(_) do
    language = language_fixture()

    %{language: language}
  end
end
