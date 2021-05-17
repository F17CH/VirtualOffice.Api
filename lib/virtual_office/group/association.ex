defmodule VirtualOffice.Group.Association do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias VirtualOffice.Repo

  alias VirtualOffice.Group.Association
  alias VirtualOffice.Group.Member

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder, only: [:id, :name, :members]}
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

  def load_association(association_id) do
    assoc = Repo.get(Association, association_id) |>
    Repo.preload(members: :user)

    IO.inspect(assoc)

    assoc
  rescue
    Ecto.Query.CastError -> :nil
  end

  def get_association(association) do
    association
  end

  def join_association(association, user_id, role) do
    {:ok, member} = Member.new(%{association_id: association.id, user_id: user_id, role: role})

    add_member(association, member)
  end

  defp add_member(assosiation, member) do
    %Association{assosiation | members: [member | assosiation.members]}
  end
end
