defmodule RideFastWeb.UserJSON do
  alias RideFast.Accounts.User

  @doc """
  Renderiza uma lista de usuários.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renderiza um único usuário.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  # Função auxiliar para formatar os dados e ESCONDER a senha
  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      role: user.role # Se tiver role no schema
    }
  end
end
