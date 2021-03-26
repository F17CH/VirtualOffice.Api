defmodule VirtualOffice.InstantMessage.ConversationServer do
  use GenServer

  alias VirtualOffice.InstantMessage.Conversation, as: Conv
  alias VirtualOffice.Account.User, as: User

  def start do
    GenServer.start(__MODULE__, nil)
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
  def init(_) do
    {:ok, Conv.new()}
  end

  @impl GenServer
  def handle_cast({:add_message, new_message, user_id}, conversation) do
    new_state = Conv.add_message(conversation, new_message, user_id)
    {:noreply, new_state}
  end

  @impl GenServer
  def handle_cast({:add_user, %User{} = user}, conversation) do
    new_state = Conv.add_user(conversation, user)
    {:noreply, new_state}
  end

  @impl GenServer
  def handle_call({:get_messages}, _, conversation) do
    {:reply, Conv.get_messages(conversation), conversation}
  end

end
