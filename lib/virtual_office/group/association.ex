defmodule VirtualOffice.Group.Association do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias VirtualOffice.Repo

  alias VirtualOffice.Group.Association
  alias VirtualOffice.Group.Member

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder, only: [:id, :name]}
  schema "associations" do
    field :name, :string
    has_many :members, Member
  end

    @doc false
    def changeset(user, attrs) do
      user
      |> cast(attrs, [:name])
      |> validate_required([:name])
    end

  def new(attrs \\ %{}) do
    %Association{}
    |> Association.changeset(attrs)
    |> Repo.insert()
  end

  def get_association(association) do
    association
  end

  def load_association(association_id) do
    Repo.get!(Association, association_id)
  end

end
