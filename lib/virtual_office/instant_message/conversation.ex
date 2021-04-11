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

  def add_message(conversation, user_id, message_content) do

    IO.inspect(user_id)
    IO.inspect(conversation.user_ids)
    case Enum.member?(conversation.user_ids, user_id) do
      true ->
        IO.puts("ADDING MESSAGE")
        new_message = Message.new(conversation.message_id, user_id, message_content)
        {:ok, %Conversation{conversation | messages: [new_message | conversation.messages], message_id: conversation.message_id + 1}}
      false ->
        IO.puts("INVALID")
        {{:error, :invalid_user}, conversation}
    end
  end

  def add_user(conversation, new_user_id) do
    case Enum.member?(conversation.user_ids, new_user_id) do
      true ->
        {{:error, :user_exists}, conversation}
      false ->
        IO.puts("User Added.")
        {:ok, %Conversation{conversation | user_ids: [new_user_id | conversation.user_ids]}}
    end
  end
end
