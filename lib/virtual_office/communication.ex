defmodule VirtualOffice.Communication do
  alias VirtualOffice.Communication.Conversation
  alias VirtualOffice.Communication.ConversationUser
  alias VirtualOffice.Communication.IndividualConversation
  alias VirtualOffice.Communication.ConversationServer
  alias VirtualOffice.Communication.ConversationCache

  import Ecto.Query, warn: false

  alias VirtualOffice.Repo

  def create_indivdual_conversation(user_id1, user_id2) do
    new_conversation = Conversation.new(%{individual: true})

    {:ok, conversation_server} = ConversationCache.server_process(new_conversation.id)
    ConversationServer.add_user(conversation_server, user_id1)
    ConversationServer.add_user(conversation_server, user_id2)
    get_conversation(new_conversation.id)
  end

  def get_individual_conversation(user_id1, user_id2) do
    conversation_id =
      Repo.one(
        from c in Conversation,
          join: u1 in assoc(c, :conversation_users),
          on:
            u1.conversation_id == c.id and
              u1.user_id == ^user_id1,
          join: u2 in assoc(c, :conversation_users),
          on:
            u2.conversation_id == c.id and
              u2.user_id == ^user_id2,
          where: c.individual == true,
          select: c.id
      )

    get_conversation(conversation_id)
  end

  def get_individual_conversations_for_user(user_id) do
    Repo.all(
      from c in Conversation,
        where:
          c.individual_user_id1 == ^user_id or
            c.individual_user_id2 == ^user_id,
        preload: [:messages, :user1, :user2]
    )
  end

  def get_conversation(conversation_id) do
    {:ok, conversation_server} = ConversationCache.server_process(conversation_id)
    ConversationServer.get_conversation(conversation_server)
  end

  def get_messages(conversation_id) do
    {:ok, conversation_server} = ConversationCache.server_process(conversation_id)
    ConversationServer.get_conversation(conversation_server)
  end

  def add_message(conversation_id, user_id, message_content) do
    {:ok, conversation_server} = ConversationCache.server_process(conversation_id)
    {:ok, ConversationServer.add_message(conversation_server, user_id, message_content)}
  end

  defp convert_to_individual_conversations_for_user_dict(conversations, user_id) do
    conversations
    |> Enum.into(
      %{},
      fn c ->
        individual_conversation = IndividualConversation.new(c, user_id)
        {individual_conversation.recipient_user.id, individual_conversation}
      end
    )
  end
end
