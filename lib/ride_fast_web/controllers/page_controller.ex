defmodule RideFastWeb.PageController do
  use RideFastWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
