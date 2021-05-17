defmodule VirtualOffice.Communication do
  alias VirtualOffice.Communication.Conversation
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
        join: u in assoc(c, :conversation_users),
        on:
          u.conversation_id == c.id and
            u.user_id == ^user_id,
        where: c.individual == true,
        preload: [:messages, conversation_users: :user]
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
end
