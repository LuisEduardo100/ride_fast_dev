defmodule RideFastWeb.AuthJSON do
  def auth_response(%{user: user, token: token, expiration: _exp}) do
    %{
      token: token,
      # expires_in: exp, # Opcional conforme YAML
      user: %{
        id: user.id,
        role: user.role,
        name: user.name,
        email: user.email
      }
    }
  end
end
