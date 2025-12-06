defmodule RideFast.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :ride_fast,
    module: RideFast.Guardian,
    error_handler: RideFast.Guardian.ErrorHandler

  # 1. Verifica se há token no Header (Authorization: Bearer <token>)
  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  # 2. Garante que o token é válido e o usuário está autenticado
  plug Guardian.Plug.EnsureAuthenticated
  # 3. Carrega o usuário no conn (opcional, mas útil para pegar user atual)
  plug Guardian.Plug.LoadResource
end
