defmodule VirtualOffice.Repo.Migrations.CreateAssociations do
  use Ecto.Migration

  def change do
    create table(:associations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
    end
  end
end
