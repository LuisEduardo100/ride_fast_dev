defmodule RideFastWeb.FallbackController do
  use RideFastWeb, :controller

  # 1. Captura erros de validação (Changeset) -> Retorna 422
  # Ele delega a formatação do JSON para o ChangesetJSON (vamos criar abaixo)
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: RideFastWeb.ChangesetJSON)
    |> render("error.json", changeset: changeset)
  end

  # 2. Captura erro de Login (Unauthorized) -> Retorna 401
  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(json: RideFastWeb.ErrorJSON)
    |> render("401.json", message: "Email ou senha incorretos")
  end

  # 3. Captura recurso não encontrado -> Retorna 404
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: RideFastWeb.ErrorJSON)
    |> render("404.json", message: "Recurso não encontrado")
  end
end
