defmodule VirtualOffice.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string, null: false
      add :password_hash, :string
      add :first_name, :text, null: false
      add :last_name, :text

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
