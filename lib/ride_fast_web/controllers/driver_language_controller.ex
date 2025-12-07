defmodule RideFastWeb.DriverLanguageController do
  use RideFastWeb, :controller
  alias RideFast.Accounts

  def index(conn, %{"driver_id" => driver_id}) do
    languages = Accounts.list_driver_languages(driver_id)
    render(conn, :index, languages: languages)
  end

  def create(conn, %{"driver_id" => driver_id, "language_id" => language_id}) do
    case Accounts.add_driver_language(driver_id, language_id) do
      {:ok, _} ->
        conn |> put_status(:created) |> json(%{status: "Language added to driver"})

      {:error, _} ->
        conn |> put_status(:conflict) |> json(%{error: "Language already linked"})
    end
  end

  def delete(conn, %{"driver_id" => driver_id, "language_id" => language_id}) do
    Accounts.remove_driver_language(driver_id, language_id)
    send_resp(conn, :no_content, "")
  end
end
