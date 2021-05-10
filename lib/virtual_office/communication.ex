defmodule VirtualOffice.Communication do
  alias VirtualOffice.Communication.Conversation
  alias VirtualOffice.Communication.ConversationServer
  alias VirtualOffice.Communication.ConversationCache

  import Ecto.Query, warn: false

  alias VirtualOffice.Repo

  def create_or_get_indivdual_conversation(user_id1, user_id2) do
    {sorted_user_id1, sorted_user_id2} = sort_user_ids(user_id1, user_id2)
    attrs = %{individual: true, individual_user_id1: sorted_user_id1, individual_user_id2: sorted_user_id2}
    Conversation.new(attrs)
  end

  def get_conversation(conversation_id) do
    {:ok, conversation_server} = ConversationCache.server_process(conversation_id)
    ConversationServer.get_conversation(conversation_server)
  end

  def add_message(conversation_id, user_id, message_content) do
    {:ok, conversation_server} = ConversationCache.server_process(conversation_id)
    {:ok, ConversationServer.add_message(conversation_server, user_id, message_content)}
  end

  defp sort_user_ids(user_id1, user_id2) do
    case user_id1 >= user_id2 do
      true ->
        {user_id1, user_id2}
      _ ->
        {user_id2, user_id1}
    end
  end
end
