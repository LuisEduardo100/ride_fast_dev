defmodule RideFast.Accounts.Driver do
  use Ecto.Schema
  import Ecto.Changeset

  schema "drivers" do
    field :name, :string
    field :email, :string
    field :phone, :string
    field :password_hash, :string
    field :status, :string
    field :password, :string, virtual: true
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(driver, attrs) do
    driver
    # 1. Adicione :password na lista de cast
    |> cast(attrs, [:name, :email, :phone, :password, :status])
    # 2. Validações básicas
    |> validate_required([:name, :email, :password, :status])
    |> unique_constraint(:email)
    # 3. A Mágica: Transforma senha em hash
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(password))
    end
  end
end
