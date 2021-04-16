defmodule VirtualOffice.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :role, :string
      add :association_id, references(:associations, type: :uuid)
      add :user_id, references(:users, type: :uuid)
    end
  end
end
