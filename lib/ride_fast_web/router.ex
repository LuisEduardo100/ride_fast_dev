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

  scope "/", RideFastWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/api/v1", RideFastWeb do
    pipe_through :api

    post "/auth/register", AuthController, :register
    post "/auth/login", AuthController, :login
  end

  scope "/api/v1", RideFastWeb do
    pipe_through [:api, RideFast.Guardian.AuthPipeline]

    # CRUD de Usuários (exceto create, que é o /register)
    resources "/users", UserController, except: [:new, :edit, :create]
    resources "/drivers", DriverController, except: [:new, :edit]
    resources "/vehicles", VehicleController, except: [:new, :edit]

    # RATINGS
    resources "/ratings", RatingController, except: [:new, :edit]

    # RIDES
    resources "/rides", RideController, except: [:new, :edit]
    post "/rides/:id/accept", RideController, :accept
    post "/rides/:id/start", RideController, :start
    post "/rides/:id/complete", RideController, :complete
    post "/rides/:id/cancel", RideController, :cancel
  end

  # Other scopes may use custom stacks.
  # scope "/api", RideFastWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ride_fast, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RideFastWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
