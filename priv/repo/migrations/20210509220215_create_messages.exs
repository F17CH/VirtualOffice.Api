defmodule VirtualOffice.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :message_id, :integer, primary_key: true
      add :conversation_id, references(:conversations, type: :uuid), primary_key: true
      add :user_id, references(:users, type: :uuid), null: false
      add :content, :string
    end

  end
end
