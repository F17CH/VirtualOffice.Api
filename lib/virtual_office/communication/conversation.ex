defmodule VirtualOffice.Communication.Conversation do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias VirtualOffice.Repo

  alias VirtualOffice.Communication.Conversation
  alias VirtualOffice.Communication.ConversationUser
  alias VirtualOffice.Communication.Message

  @derive {Jason.Encoder, only: [:id, :individual, :messages, :conversation_users]}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "conversations" do
    field :individual, :boolean
    has_many :conversation_users, ConversationUser
    field :message_count, :integer
    has_many :messages, Message
  end

  def new_changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:individual])
    |> validate_required([:individual])
  end

  def update_changeset(conversation, attrs) do
    conversation
    |> change(attrs)
  end

  def new(attrs \\ %{}) do
    %Conversation{message_count: 0}
    |> Conversation.new_changeset(attrs)
    |> Repo.insert!()
  end

  def load(conversation_id) do
    Repo.get(Conversation, conversation_id)
    |> Repo.preload([:messages, conversation_users: :user])
  rescue
    Ecto.Query.CastError -> nil
  end

  def save(conversation = %Conversation{}, attrs) do
    IO.inspect(attrs)

    conversation
    |> Conversation.update_changeset(attrs)
    |> Repo.update()
  end

  def get_conversation(conversation) do
    conversation
  end

  def get_messages(conversation) do
    conversation.messages
  end

  def get_users(conversation) do
    conversation.conversation_users
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
            {:ok, conversation} =
              save(conversation, %{message_count: conversation.message_count + 1})

            {new_message,
             %Conversation{
               conversation
               | messages: [new_message | conversation.messages],
                 message_count: conversation.message_count
             }}

          _ ->
            conversation
        end

      false ->
        IO.puts("#{conversation.id}: Invalid User.")
        {{:error, :invalid_user}, conversation}
    end
  end

  def add_user(conversation, new_user_id) do
    case ConversationUser.new(%{conversation_id: conversation.id, user_id: new_user_id}) do
      {:ok, new_conversation_user = %ConversationUser{}} ->
        {new_conversation_user,
         %Conversation{
           conversation
           | conversation_users: [new_conversation_user | conversation.conversation_users]
         }}

      _ ->
        conversation
    end
  end

  defp valid_user(conversation = %Conversation{}, user_id) do
    Enum.find_value(
      conversation.conversation_users,
      false,
      fn conversation_user ->
        conversation_user.user_id == user_id
      end
    )
  end
end
