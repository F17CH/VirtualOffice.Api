defmodule VirtualOffice.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :individual, :boolean, null: false
      add :message_count, :integer, null: false
    end
  end
end
