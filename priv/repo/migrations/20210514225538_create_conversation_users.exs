defmodule VirtualOffice.Repo.Migrations.CreateConversationUsers do
  use Ecto.Migration

  def change do
    create table(:conversation_users, primary_key: false) do
      add :conversation_id, references(:conversations, type: :uuid), null: false
      add :user_id, references(:users, type: :uuid), null: false
    end

  create unique_index(:conversation_users, [:conversation_id, :user_id])
  end
end
