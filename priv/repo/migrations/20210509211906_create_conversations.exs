defmodule VirtualOffice.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :individual, :boolean, null: false
      add :individual_user_id1, references(:users, type: :uuid), null: true
      add :individual_user_id2, references(:users, type: :uuid), null: true
      add :message_count, :integer, null: false
    end

    create unique_index(:conversations, [:individual_user_id1, :individual_user_id2])
  end
end
