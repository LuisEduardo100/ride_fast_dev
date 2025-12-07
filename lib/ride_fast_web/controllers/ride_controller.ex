defmodule RideFastWeb.RideController do
  use RideFastWeb, :controller

  alias RideFast.Operation
  alias RideFast.Operation.Ride
  alias RideFast.Guardian
  alias RideFast.Accounts.Driver
  alias RideFast.Repo

  action_fallback RideFastWeb.FallbackController

  def index(conn, _params) do
    rides = Operation.list_rides()
    render(conn, :index, rides: rides)
  end

  def create(conn, %{"ride" => ride_params}) do
    with {:ok, %Ride{} = ride} <- Operation.create_ride(ride_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/rides/#{ride}")
      |> render(:show, ride: ride)
    end
  end

  def create(conn, %{"origin" => origin, "destination" => dest}) do
    user = Guardian.Plug.current_resource(conn)

    ride_params = %{
      "user_id" => user.id,
      "status" => "SOLICITADA",
      "requested_at" => NaiveDateTime.utc_now(),
      "origin_lat" => origin["lat"],
      "origin_lng" => origin["lng"],
      "dest_lat" => dest["lat"],
      "dest_lng" => dest["lng"],
      "price_estimate" => 25.00
    }

    with {:ok, %Ride{} = ride} <- Operation.create_ride(ride_params) do
      conn
      |> put_status(:created)
      |> render(:show, ride: ride)
    end
  end

  def create(conn, %{"ride" => ride_params}) do
    # Tenta adaptar ou segue o fluxo padrão
    create(conn, ride_params)
  end

  def accept(conn, %{"id" => id, "vehicle_id" => vehicle_id}) do
    user = Guardian.Plug.current_resource(conn)
    IO.puts("\n=== DEBUG RIDE ACCEPT ===")
    IO.puts("User Logado: #{user.email} (ID: #{user.id})")

    driver = Repo.get_by(Driver, email: user.email)

    cond do
      is_nil(driver) ->
        IO.puts("ERRO: Motorista não encontrado na tabela 'drivers' com esse email!")

        conn
        |> put_status(:forbidden)
        |> json(%{
          error:
            "Motorista não encontrado. Verifique se criou o perfil em POST /drivers com o mesmo email."
        })

      true ->
        IO.puts("Motorista Encontrado: #{driver.email} (ID REAL: #{driver.id})")

        ride = Operation.get_ride!(id)

        case Operation.accept_ride(ride, driver.id, vehicle_id) do
          {:ok, %Ride{} = ride} ->
            IO.puts("SUCESSO: Corrida aceita!")
            render(conn, :show, ride: ride)

          {:error, changeset} ->
            IO.puts("ERRO DE CHANGESET OU BANCO")

            conn
            |> put_status(:conflict)
            |> json(%{error: "Erro ao aceitar corrida (verifique vehicle_id ou status)"})
        end
    end
  end

  def show(conn, %{"id" => id}) do
    ride = Operation.get_ride!(id)
    render(conn, :show, ride: ride)
  end

  def update(conn, %{"id" => id, "ride" => ride_params}) do
    ride = Operation.get_ride!(id)

    with {:ok, %Ride{} = ride} <- Operation.update_ride(ride, ride_params) do
      render(conn, :show, ride: ride)
    end
  end

  def delete(conn, %{"id" => id}) do
    ride = Operation.get_ride!(id)

    with {:ok, %Ride{}} <- Operation.delete_ride(ride) do
      send_resp(conn, :no_content, "")
    end
  end

  def start(conn, %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn)
    # Busca o motorista pelo email
    driver = Repo.get_by(Driver, email: user.email)

    ride = Operation.get_ride!(id)

    cond do
      is_nil(driver) ->
        conn |> put_status(:forbidden) |> json(%{error: "Motorista não identificado."})

      # SEGURANÇA: Só o motorista que aceitou a corrida pode iniciá-la
      ride.driver_id != driver.id ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Esta corrida pertence a outro motorista."})

      true ->
        with {:ok, %Ride{} = ride} <- Operation.start_ride(ride) do
          render(conn, :show, ride: ride)
        end
    end
  end

  # FINALIZAR A CORRIDA
  def complete(conn, %{"id" => id, "final_price" => final_price}) do
    user = Guardian.Plug.current_resource(conn)
    driver = Repo.get_by(Driver, email: user.email)

    ride = Operation.get_ride!(id)

    cond do
      is_nil(driver) ->
        conn |> put_status(:forbidden) |> json(%{error: "Motorista não identificado."})

      ride.driver_id != driver.id ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Esta corrida pertence a outro motorista."})

      true ->
        with {:ok, %Ride{} = ride} <- Operation.complete_ride(ride, final_price) do
          render(conn, :show, ride: ride)
        end
    end
  end
end
