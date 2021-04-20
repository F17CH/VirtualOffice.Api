defmodule VirtualOffice.InstantMessage.ConversationServer do
  use GenServer, restart: :temporary

  alias VirtualOffice.InstantMessage.ConversationServer, as: Server
  alias VirtualOffice.InstantMessage.Conversation, as: Conversation

  def start_link(conversation_id) do
    IO.puts("Starting GenServer for Conversation: #{conversation_id}")

    GenServer.start_link(Server, conversation_id, name: global_name(conversation_id))
  end

  def get_conversation(conversation_server) do
    GenServer.call(conversation_server, {:get_conversation})
  end

  def get_messages(conversation_server) do
    GenServer.call(conversation_server, {:get_messages})
  end

  def get_users(conversation_server) do
    GenServer.call(conversation_server, {:get_users})
  end

  def add_message(conversation_server, user_id, message_content) do
    GenServer.call(conversation_server, {:add_message, user_id, message_content})
  end

  def add_user(conversation_server, user_id) do
    GenServer.call(conversation_server, {:add_user, user_id})
  end

  @impl GenServer
  def init(conversation_id) do
    {:ok, Conversation.new(conversation_id)}
  end

  @impl GenServer
  def handle_call({:get_conversation}, _, conversation) do
    {:reply, Conversation.get_conversation(conversation), conversation}
  end

  @impl GenServer
  def handle_call({:get_users}, _, conversation) do
    {:reply, Conversation.get_users(conversation), conversation}
  end

  @impl GenServer
  def handle_call({:get_messages}, _, conversation) do
    {:reply, Conversation.get_messages(conversation), conversation}
  end

  @impl GenServer
  def handle_call({:add_user, user_id}, _, conversation) do
    {result, new_state} = Conversation.add_user(conversation, user_id)
    {:reply, result, new_state}
  end

  @impl GenServer
  def handle_call({:add_message, user_id, message_content}, _, conversation) do
    {response, new_state} = Conversation.add_message(conversation, user_id, message_content)
    {:reply, response, new_state}
  end

  def whereis(conversation_id) do
    case :global.whereis_name({__MODULE__, conversation_id}) do
      :undefined -> nil
      pid -> pid
    end
  end

  defp global_name(conversation_id) do
    {:global, {__MODULE__, conversation_id}}
  end

end
