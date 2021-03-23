defmodule VirtualOffice.Repo.Migrations.UsersAddNamingColumns do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :first_name, :text, null: false
      add :last_name, :text
    end
  end
end
