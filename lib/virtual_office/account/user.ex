defmodule VirtualOffice.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias VirtualOffice.Group.Member

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder, only: [:id, :email, :first_name, :last_name]}
  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :first_name, :string
    field :last_name, :string
    has_many :members, Member

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation, :first_name, :last_name])
    |> validate_required([:email, :password, :password_confirmation, :first_name])
    |> validate_format(:email, ~r/@/)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(
    %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Pbkdf2.add_hash(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end
end
