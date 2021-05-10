defmodule VirtualOffice.Communication.Conversation do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias VirtualOffice.Repo

  alias VirtualOffice.Group.Association
  alias VirtualOffice.Group.Member
  alias VirtualOffice.Communication.Conversation, as: Conversation
  alias VirtualOffice.Communication.Message, as: Message

  @derive {Jason.Encoder, only: [:id, :individual, :individual_user_id1, :individual_user_id2, :messages]}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "conversations" do
    field :individual, :boolean
    belongs_to :user1, User, foreign_key: :individual_user_id1
    belongs_to :user2, User, foreign_key: :individual_user_id2
    field :message_count, :integer
    has_many :messages, Message
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:individual, :individual_user_id1, :individual_user_id2])
    |> validate_required([:individual])
  end

  def new(attrs \\ %{}) do
    %Conversation{message_count: 0}
    |> Conversation.changeset(attrs)
    |> Repo.insert!()
  end

  def load_conversation(conversation_id) do
    Repo.get(Conversation, conversation_id)
    |> Repo.preload(:messages)
#  rescue
#    Ecto.Query.CastError -> nil
  end

  def get_conversation(conversation) do
    conversation
  end

  def get_messages(conversation) do
    conversation.messages
  end

  def get_users(conversation) do
    conversation.user_ids
  end

  def add_message(conversation, user_id, message_content) do
    case valid_user(conversation, user_id) do
      true ->
        IO.puts("#{conversation.id}: Message Added.")

        case Message.new(%{
               message_id: conversation.message_count + 1,
               conversation_id: conversation.id,
               user_id: user_id,
               content: message_content
             }) do
          {:ok, new_message = %Message{}} ->
            IO.puts("HERE")
            {new_message, %Conversation{
              conversation
              | messages: [new_message | conversation.messages],
                message_count: conversation.message_count + 1
            }}
          _ ->
            IO.puts("HERE123")
            conversation
        end

      false ->
        IO.puts("#{conversation.id}: Invalid User.")
        {{:error, :invalid_user}, conversation}
    end
  end

  #  def add_user(conversation, new_user_id) do
  #    case valid_user(conversation, new_user_id) do
  #      true ->
  #        IO.puts("#{conversation.id}: User Already Exists.")
  #        {{:error, :user_exists}, conversation}
  #
  #      false ->
  #        IO.puts("#{conversation.id}: User Added.")
  #        {:ok, %Conversation{conversation | user_ids: [new_user_id | conversation.user_ids]}}
  #    end
  #  end
  #
  defp valid_user(conversation = %Conversation{}, user_id) do
    user_id == conversation.individual_user_id1 || user_id == conversation.individual_user_id2
  end
end
