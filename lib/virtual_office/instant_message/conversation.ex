defmodule VirtualOffice.InstantMessage.Conversation do
  defstruct message_id: 1, messages: [], users: %VirtualOffice.Account.User{}

  alias VirtualOffice.InstantMessage.Conversation, as: Conversation
  alias VirtualOffice.Account.User, as: User

  def new(), do: %Conversation{}

  def add_message(conversation, message, user_id) do

    case Map.has_key?(conversation.users, user_id) do
      true ->
        new_message = %{id: conversation.message_id, message: message, user_id: user_id}
        %Conversation{conversation | messages: [new_message | conversation.messages], message_id: conversation.message_id + 1}
      false ->
        {:error, :invalid_user}
    end
  end

  def add_user(conversation, %User{} = user) do

    case Map.has_key?(conversation.users, user.id) do
      true ->
        {:error, :user_exists}
      false ->
        %Conversation{conversation | users: Map.put(conversation.users, user.id, user)}
    end
  end

  def get_messages(conversation) do
    {conversation.messages}
  end
end
