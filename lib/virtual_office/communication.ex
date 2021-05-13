defmodule VirtualOffice.Communication do
  alias VirtualOffice.Communication.Conversation
  alias VirtualOffice.Communication.IndividualConversation
  alias VirtualOffice.Communication.ConversationServer
  alias VirtualOffice.Communication.ConversationCache

  import Ecto.Query, warn: false

  alias VirtualOffice.Repo

  def create_indivdual_conversation(user_id1, user_id2) do
    {sorted_user_id1, sorted_user_id2} = sort_user_ids(user_id1, user_id2)
    attrs = %{individual: true, individual_user_id1: sorted_user_id1, individual_user_id2: sorted_user_id2}
    Conversation.new(attrs)
  end

  def get__indivdual_conversation(user_id1, user_id2) do
    {sorted_user_id1, sorted_user_id2} = sort_user_ids(user_id1, user_id2)

    conversation_id = Repo.one(
      from c in Conversation,
        where: c.individual_user_id1 == ^sorted_user_id1
        and c.individual_user_id2 == ^sorted_user_id2,
        select: c.id
    )

    get_conversation(conversation_id)
  end

  def get_individual_conversations_for_user(user_id) do
        conversations = Repo.all(
        from c in Conversation,
        where: c.individual_user_id1 == ^user_id
        or c.individual_user_id2 == ^user_id,
        preload: [:messages, :user1]
      )

      convert_to_individual_conversations_for_user(conversations, user_id)
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

  defp convert_to_individual_conversations_for_user(conversations, user_id) do
    conversations |>
    Enum.into(%{},
    fn c ->
      individual_conversation = IndividualConversation.new(c, user_id)
      {individual_conversation.recipient_user.id, individual_conversation}
    end
    )
  end
end
