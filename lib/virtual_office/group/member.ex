defmodule VirtualOffice.Group.Member do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias VirtualOffice.Repo

  alias VirtualOffice.Group.Member
  alias VirtualOffice.Group.Association
  alias VirtualOffice.Account.User

  @primary_key false
  @foreign_key_type :binary_id
  @derive {Jason.Encoder, only: [:user, :role]}
  schema "members" do
    belongs_to :association, Association
    belongs_to :user, User
    field :role, :string
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:association_id, :user_id, :role])
    |> validate_required([:association_id, :user_id, :role])
  end

  def new(attrs \\ %{}) do
    %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert()
  end

  def save(member = %Member{}) do
    Repo.insert(member)
  end
end
