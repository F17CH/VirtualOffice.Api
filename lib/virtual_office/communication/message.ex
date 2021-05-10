defmodule VirtualOffice.Communication.Message do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias VirtualOffice.Repo

  alias VirtualOffice.Communication.Message
  alias VirtualOffice.Communication.Conversation
  alias VirtualOffice.Account.User

  @derive {Jason.Encoder, only: [:message_id, :user_id, :content]}
  @primary_key false
  @foreign_key_type :binary_id
  schema "messages" do
    field :message_id, :integer, primary_key: true
    belongs_to :conversation, Conversation, primary_key: true
    belongs_to :user, User
    field :content, :string
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:message_id, :conversation_id, :user_id, :content])
    |> validate_required([:message_id, :conversation_id, :user_id, :content])
  end

  def new(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end
end
