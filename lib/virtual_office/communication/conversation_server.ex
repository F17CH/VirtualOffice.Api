defmodule VirtualOffice.Communication.ConversationServer do
  use GenServer, restart: :temporary

  alias VirtualOffice.Communication.ConversationServer
  alias VirtualOffice.Communication.Conversation

  @conversation_timeout_ms 100_000

  def start_link(conversation_id) do
    IO.puts("Starting GenServer for Conversation: #{conversation_id}")

    GenServer.start_link(ConversationServer, conversation_id, name: global_name(conversation_id))
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
    case Conversation.load(conversation_id) do
      nil -> {:stop, {:shutdown, :invalid_conversation}}
      conversation -> {:ok, conversation, @conversation_timeout_ms}
    end
  end

  @impl GenServer
  def handle_info(:timeout, conversation) do
    {:stop, :normal, conversation}
  end

  @impl GenServer
  def terminate(:normal, conversation) do
    IO.puts("Stopping GenServer for Conversation: #{conversation.id}")
  end

  @impl GenServer
  def handle_call({:get_conversation}, _, conversation) do
    {:reply, Conversation.get_conversation(conversation), conversation, @conversation_timeout_ms}
  end

  @impl GenServer
  def handle_call({:get_users}, _, conversation) do
    {:reply, Conversation.get_users(conversation), conversation, @conversation_timeout_ms}
  end

  @impl GenServer
  def handle_call({:get_messages}, _, conversation) do
    {:reply, Conversation.get_messages(conversation), conversation, @conversation_timeout_ms}
  end

  @impl GenServer
  def handle_call({:add_user, user_id}, _, conversation) do
    {result, new_conversation_state} = Conversation.add_user(conversation, user_id)
    {:reply, result, new_conversation_state, @conversation_timeout_ms}
  end

  @impl GenServer
  def handle_call({:add_message, user_id, message_content}, _, conversation) do
    {response, new_conversation_state} =
      Conversation.add_message(conversation, user_id, message_content)

    {:reply, response, new_conversation_state, @conversation_timeout_ms}
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
