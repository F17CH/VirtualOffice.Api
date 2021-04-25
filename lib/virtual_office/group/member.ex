defmodule VirtualOffice.Group.Member do
  use Ecto.Schema

  alias VirtualOffice.Group.Association
  alias VirtualOffice.Account.User

  schema "members" do
    field :role, :string
    belongs_to :associations, Association
    belongs_to :users, User
  end
end
