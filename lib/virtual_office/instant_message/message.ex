defmodule VirtualOffice.InstantMessage.Message do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias VirtualOffice.Repo

  alias VirtualOffice.InstantMessage.Message
  alias VirtualOffice.InstantMessage.Conversation
  alias VirtualOffice.Account.User

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "messages" do
    field :message_id, :integer, primary_key: true
    belongs_to :conversation, Conversation, primary_key: true
    belongs_to :user, User
    field :content, :string
  end

  def new(message_id, user_id, content) do
    %Message{id: message_id, user_id: user_id, content: content}
  end
end
