defmodule RideFast.Operation do
  @moduledoc """
  The Operation context.
  """

  import Ecto.Query, warn: false
  alias RideFast.Repo

  alias RideFast.Operation.Ride

  @doc """
  Returns the list of rides.

  ## Examples

      iex> list_rides()
      [%Ride{}, ...]

  """
  def list_rides do
    Repo.all(Ride)
  end

  @doc """
  Gets a single ride.

  Raises `Ecto.NoResultsError` if the Ride does not exist.

  ## Examples

      iex> get_ride!(123)
      %Ride{}

      iex> get_ride!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ride!(id), do: Repo.get!(Ride, id)

  @doc """
  Creates a ride.

  ## Examples

      iex> create_ride(%{field: value})
      {:ok, %Ride{}}

      iex> create_ride(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ride(attrs) do
    %Ride{}
    |> Ride.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ride.

  ## Examples

      iex> update_ride(ride, %{field: new_value})
      {:ok, %Ride{}}

      iex> update_ride(ride, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ride(%Ride{} = ride, attrs) do
    ride
    |> Ride.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ride.

  ## Examples

      iex> delete_ride(ride)
      {:ok, %Ride{}}

      iex> delete_ride(ride)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ride(%Ride{} = ride) do
    Repo.delete(ride)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ride changes.

  ## Examples

      iex> change_ride(ride)
      %Ecto.Changeset{data: %Ride{}}

  """
  def change_ride(%Ride{} = ride, attrs \\ %{}) do
    Ride.changeset(ride, attrs)
  end

  def accept_ride(%Ride{} = ride, driver_id, vehicle_id) do
    # [cite_start]Regra: Só pode aceitar se estiver SOLICITADA [cite: 356]
    if ride.status == "SOLICITADA" do
      ride
      |> Ride.changeset(%{
        status: "ACEITA",
        driver_id: driver_id,
        vehicle_id: vehicle_id
      })
      |> Repo.update()
    else
      {:error, "Ride is not available (status: #{ride.status})"}
    end
  end

  def start_ride(%Ride{} = ride) do
    ride
    |> Ride.changeset(%{
      status: "EM_ANDAMENTO",
      started_at: NaiveDateTime.utc_now()
    })
    |> Repo.update()
  end

  def complete_ride(%Ride{} = ride, final_price) do
    ride
    |> Ride.changeset(%{
      status: "FINALIZADA",
      ended_at: NaiveDateTime.utc_now(),
      final_price: final_price
    })
    |> Repo.update()
  end
end
