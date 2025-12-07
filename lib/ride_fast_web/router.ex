defmodule RideFastWeb.Router do
  use RideFastWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RideFastWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # --- ROTAS PÚBLICAS ---
  scope "/", RideFastWeb do
    pipe_through :browser
    get "/", PageController, :home
  end

  scope "/api/v1", RideFastWeb do
    pipe_through :api
    post "/auth/register", AuthController, :register
    post "/auth/login", AuthController, :login
  end

  # --- ROTAS PROTEGIDAS (TOKEN) ---
  scope "/api/v1", RideFastWeb do
    pipe_through [:api, RideFast.Guardian.AuthPipeline]

    # 1. USUÁRIOS
    resources "/users", UserController, except: [:new, :edit, :create] do
      get "/ratings", RatingController, :index_by_user # Ver avaliações do usuário
    end

    # 2. MOTORISTAS (Aninhamento)
    resources "/drivers", DriverController, except: [:new, :edit] do
      # VEÍCULOS: Cria a rota /drivers/:driver_id/vehicles
      resources "/vehicles", VehicleController, only: [:index, :create]

      # PERFIL: Cria a rota /drivers/:driver_id/profile
      get "/profile", DriverProfileController, :show
      post "/profile", DriverProfileController, :create
      put "/profile", DriverProfileController, :update

      # IDIOMAS DO MOTORISTA
      get "/languages", DriverLanguageController, :index
      post "/languages/:language_id", DriverLanguageController, :create
      delete "/languages/:language_id", DriverLanguageController, :delete

      # AVALIAÇÕES DO MOTORISTA
      get "/ratings", RatingController, :index_by_driver
    end

    # 3. VEÍCULOS (Rotas soltas para Update/Delete usando apenas o ID do veículo)
    resources "/vehicles", VehicleController, only: [:update, :delete, :show]

    # 4. CORRIDAS
    resources "/rides", RideController, except: [:new, :edit] do
      post "/ratings", RatingController, :create
      get "/ratings", RatingController, :index_by_ride
      get "/history", RideController, :history
    end

    # Ações Específicas da Corrida
    post "/rides/:id/accept", RideController, :accept
    post "/rides/:id/start", RideController, :start
    post "/rides/:id/complete", RideController, :complete
    post "/rides/:id/cancel", RideController, :cancel

    # 5. AVALIAÇÕES e IDIOMAS (Geral)
    resources "/ratings", RatingController, only: [:show]
    resources "/languages", LanguageController, except: [:new, :edit]
  end

  # --- DASHBOARD (DEV) ---
  if Application.compile_env(:ride_fast, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: RideFastWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
