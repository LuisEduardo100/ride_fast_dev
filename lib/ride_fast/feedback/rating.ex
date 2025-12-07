defmodule RideFast.Feedback.Rating do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ratings" do
    field :score, :integer
    field :comment, :string
    field :ride_id, :id
    field :from_user_id, :id
    field :to_driver_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:score, :comment, :ride_id, :from_user_id, :to_driver_id])
    |> validate_required([:score, :comment, :ride_id, :from_user_id, :to_driver_id])
  end
end
