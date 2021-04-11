defmodule VirtualOffice.InstantMessage.ConversationCache do

  alias VirtualOffice.InstantMessage.ConversationServer

  def start_link() do
    IO.puts("Starting Conversation Cache.")

    DynamicSupervisor.start_link(
      name: __MODULE__,
      strategy: :one_for_one
    )
  end

  defp start_child(conversation_id) do
    DynamicSupervisor.start_child(
      __MODULE__,
      {VirtualOffice.InstantMessage.ConversationServer, conversation_id}
    )
  end

  def create_conversation() do
    new_conversation_id = UUID.uuid4()

    start_child(new_conversation_id)
  end

  def get_conversation(conversation_id) do
    ConversationServer.whereis(conversation_id)
  end

  def child_spec(_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end


end
