defmodule VirtualOffice.Communication.ConversationUser do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias VirtualOffice.Repo

  alias VirtualOffice.Communication.ConversationUser
  alias VirtualOffice.Account.User
  alias VirtualOffice.Communication.Conversation

  @derive {Jason.Encoder, only: [:user]}
  @primary_key false
  @foreign_key_type :binary_id
  schema "conversation_users" do
    belongs_to :conversation, Conversation
    belongs_to :user, User
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:conversation_id, :user_id])
    |> validate_required([:conversation_id, :user_id])
  end

  def new(attrs \\ %{}) do
    new_conversation_user_result = %ConversationUser{}
    |> ConversationUser.changeset(attrs)
    |> Repo.insert()

    IO.inspect(new_conversation_user_result)

    case new_conversation_user_result do
      {:ok, new_conversation_user} ->
        {:ok, Repo.preload(new_conversation_user, :user)}
    end
  end
end
