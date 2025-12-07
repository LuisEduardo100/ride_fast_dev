defmodule RideFastWeb.RideController do
  use RideFastWeb, :controller

  alias RideFast.Operation
  alias RideFast.Operation.Ride
  alias RideFast.Guardian
  alias RideFast.Accounts.Driver
  alias RideFast.Repo

  action_fallback RideFastWeb.FallbackController

  def index(conn, params) do
    rides =
      if status = params["status"] do
        Operation.list_rides_by_status(status)
      else
        Operation.list_rides()
      end

    render(conn, :index, rides: rides)
  end

  def create(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    origin = params["origin"] || %{}
    dest = params["destination"] || %{}

    ride_attrs = %{
      "user_id" => user.id,
      "status" => "SOLICITADA",
      "requested_at" => NaiveDateTime.utc_now(),
      "origin_lat" => origin["lat"],
      "origin_lng" => origin["lng"],
      "dest_lat" => dest["lat"],
      "dest_lng" => dest["lng"],
      "price_estimate" => 25.0,
      "final_price" => nil
    }

    with {:ok, %Ride{} = ride} <- Operation.create_ride(ride_attrs) do
      conn
      |> put_status(:created)
      |> render(:show, ride: ride)
    end
  end

  def accept(conn, %{"id" => id, "vehicle_id" => vehicle_id}) do
    user = Guardian.Plug.current_resource(conn)
    driver = Repo.get_by(RideFast.Accounts.Driver, email: user.email)

    if is_nil(driver) do
      conn |> put_status(:forbidden) |> json(%{error: "Not a driver"})
    else
      result =
        Repo.transaction(fn ->
          ride = Repo.get!(Ride, id, lock: "FOR UPDATE")

          cond do
            ride.status != "SOLICITADA" ->
              Repo.rollback("Ride already taken or cancelled")

            true ->
              case Operation.accept_ride(ride, driver.id, vehicle_id) do
                {:ok, updated_ride} -> updated_ride
                {:error, _reason} -> Repo.rollback("Validation error")
              end
          end
        end)

      case result do
        {:ok, ride} ->
          render(conn, :show, ride: ride)

        {:error, message} ->
          conn |> put_status(:conflict) |> json(%{error: message})
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
  def complete(conn, %{"id" => id, "final_price" => final_price} = params) do
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

  def cancel(conn, %{"id" => id} = params) do
    reason = params["reason"] || "Sem motivo informado"
    ride = Operation.get_ride!(id)

    if ride.status == "FINALIZADA" do
      conn
      |> put_status(:conflict)
      |> json(%{error: "Não é possível cancelar uma corrida já finalizada."})
    else
      with {:ok, %Ride{} = ride} <- Operation.cancel_ride(ride, reason) do
        render(conn, :show, ride: ride)
      end
    end
  end

  def history(conn, %{"id" => id}) do
    ride = Operation.get_ride!(id)

    # 1. Evento Inicial
    events = [
      %{
        action: "REQUESTED",
        from_state: "NONE",
        to_state: "SOLICITADA",
        actor: "User ID #{ride.user_id}",
        timestamp: ride.requested_at
      }
    ]

    # 2. Evento Aceito
    events =
      if ride.driver_id do
        events ++
          [
            %{
              action: "ACCEPTED",
              from_state: "SOLICITADA",
              to_state: "ACEITA",
              actor: "Driver ID #{ride.driver_id}",
              timestamp: ride.updated_at
            }
          ]
      else
        events
      end

    # 3. Evento Iniciado
    events =
      if ride.started_at do
        events ++
          [
            %{
              action: "STARTED",
              from_state: "ACEITA",
              to_state: "EM_ANDAMENTO",
              actor: "Driver ID #{ride.driver_id}",
              timestamp: ride.started_at
            }
          ]
      else
        events
      end

    # 4. Evento Finalizado (AQUI ESTAVA O ERRO)
    # Trocamos 'and' por '&&' para aceitar a data
    events =
      if ride.ended_at && ride.status == "FINALIZADA" do
        events ++
          [
            %{
              action: "COMPLETED",
              from_state: "EM_ANDAMENTO",
              to_state: "FINALIZADA",
              actor: "Driver ID #{ride.driver_id}",
              timestamp: ride.ended_at
            }
          ]
      else
        events
      end

    # 5. Evento Cancelado
    events =
      if ride.status == "CANCELADA" do
        events ++
          [
            %{
              action: "CANCELLED",
              from_state: "UNKNOWN",
              to_state: "CANCELADA",
              actor: "User/Driver",
              timestamp: ride.updated_at
            }
          ]
      else
        events
      end

    json(conn, %{data: events})
  end
end
