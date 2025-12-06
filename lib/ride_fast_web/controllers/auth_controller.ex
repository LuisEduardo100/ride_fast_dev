defmodule RideFastWeb.AuthController do
  use RideFastWeb, :controller

  alias RideFast.Accounts
  alias RideFast.Accounts.User
  alias RideFast.Guardian

  action_fallback RideFastWeb.FallbackController

  def register(conn, params) do
    # O PDF pede role no body. O changeset já trata isso.
    with {:ok, %User{} = user} <- Accounts.create_user(params),
         {:ok, token, claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render(:auth_response, user: user, token: token, expiration: claims["exp"])
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    with {:ok, %User{} = user} <- Accounts.authenticate_user(email, password),
         {:ok, token, claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:ok)
      |> render(:auth_response, user: user, token: token, expiration: claims["exp"])
    end
  end
end
