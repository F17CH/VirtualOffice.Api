defmodule Group.Association do
  use Ecto.Schema

  alias VirtualOffice.Group.Member

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "associations" do
    field :name, :string
    has_many :members, Member
  end
end
