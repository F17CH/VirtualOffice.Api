defmodule VirtualOffice.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members, primary_key: false) do
      add :association_id, references(:associations, type: :uuid), null: false
      add :user_id, references(:users, type: :uuid), null: false
      add :role, :string
    end

  create index(:members, [:association_id])
  create index(:members, [:user_id])
  create unique_index(:members, [:user_id, :association_id])
  end

end
