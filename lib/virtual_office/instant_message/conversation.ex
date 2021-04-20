defmodule VirtualOffice.InstantMessage.Conversation do
  @derive {Jason.Encoder, only: [:id, :messages, :user_ids]}
  defstruct id: "", message_id: 1, messages: [], user_ids: []

  alias VirtualOffice.InstantMessage.Conversation, as: Conversation
  alias VirtualOffice.InstantMessage.Message, as: Message

  def new(conversation_id) do
    %Conversation{id: conversation_id}
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
        new_message = Message.new(conversation.message_id, user_id, message_content)
        {{:ok, new_message}, %Conversation{conversation | messages: [new_message | conversation.messages], message_id: conversation.message_id + 1}}
      false ->
        IO.puts("#{conversation.id}: Invalid User.")
        {{:error, :invalid_user}, conversation}
    end
  end

  def add_user(conversation, new_user_id) do
    case valid_user(conversation, new_user_id) do
      true ->
        IO.puts("#{conversation.id}: User Already Exists.")
        {{:error, :user_exists}, conversation}
      false ->
        IO.puts("#{conversation.id}: User Added.")
        {:ok, %Conversation{conversation | user_ids: [new_user_id | conversation.user_ids]}}
    end
  end

  defp valid_user(conversation, user_id) do
    Enum.member?(conversation.user_ids, user_id)
  end
end
