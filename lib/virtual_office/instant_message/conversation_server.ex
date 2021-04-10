defmodule VirtualOffice.InstantMessage.ConversationServer do
  use GenServer, restart: :temporary

  alias VirtualOffice.InstantMessage.ConversationServer, as: Server
  alias VirtualOffice.InstantMessage.ConversationRegistry, as: Registry
  alias VirtualOffice.InstantMessage.Conversation, as: Conversation
  alias VirtualOffice.Account.User, as: User

  def start_link(conversation_id) do
    IO.puts("Starting Server for Conversation: #{conversation_id}.")

    GenServer.start_link(Server, conversation_id, name: global_name(conversation_id))
  end

  def add_message(conversation_server, new_message, user_id) do
    GenServer.cast(conversation_server, {:add_message, new_message, user_id})
  end

  def add_user(conversation_server, %User{} = user) do
    GenServer.cast(conversation_server, {:add_user, user})
  end

  def get_messages(conversation_server) do
    GenServer.call(conversation_server, {:get_messages})
  end

  @impl GenServer
  def init(conversation_id) do
    {:ok, Conversation.new(conversation_id)}
  end

  @impl GenServer
  def handle_cast({:add_message, new_message, user_id}, conversation) do
    new_state = Conversation.add_message(conversation, new_message, user_id)
    {:noreply, new_state}
  end

  @impl GenServer
  def handle_cast({:add_user, %User{} = user}, conversation) do
    new_state = Conversation.add_user(conversation, user)
    {:noreply, new_state}
  end

  @impl GenServer
  def handle_call({:get_messages}, _, conversation) do
    {:reply, Conversation.get_messages(conversation), conversation}
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
