defmodule RideFastWeb.UserController do
  use RideFastWeb, :controller

  alias RideFast.Accounts
  alias RideFast.Accounts.User

  action_fallback RideFastWeb.FallbackController

  # GET /api/v1/users
  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  # GET /api/v1/users/:id
  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  # PUT /api/v1/users/:id
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  # DELETE /api/v1/users/:id
  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
