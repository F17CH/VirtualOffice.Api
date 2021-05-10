defmodule VirtualOffice.Communication.ConversationCache do

  alias VirtualOffice.Communication.ConversationServer

  def start_link() do
    IO.puts("Starting Conversation Cache.")

    DynamicSupervisor.start_link(
      name: __MODULE__,
      strategy: :one_for_one
    )
  end

  def server_process(conversation_id) do
    case existing_process(conversation_id) || new_process(conversation_id) do
      {:error, message} ->
        {:error, message}

      pid ->
        {:ok, pid}
    end
  end

  defp existing_process(conversation_id) do
    ConversationServer.whereis(conversation_id)
  end

  defp new_process(conversation_id) do
    case DynamicSupervisor.start_child(
           __MODULE__,
           {ConversationServer, conversation_id}
         ) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
      {:error, {:shutdown, reason}} -> {:error, reason}
    end
  end

  def child_spec(_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end


end
