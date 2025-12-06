defmodule RideFast.Guardian do
  use Guardian, otp_app: :ride_fast

  alias RideFast.Accounts

  # Transforma o recurso (User) em uma string para o token (geralmente o ID)
  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  # Recupera o recurso (User) a partir do token
  def resource_from_claims(%{"sub" => id}) do
    user = Accounts.get_user!(id)
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end
end
