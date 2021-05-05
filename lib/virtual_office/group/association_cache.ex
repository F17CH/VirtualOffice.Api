defmodule VirtualOffice.Group.AssociationCache do
  alias VirtualOffice.Group.AssociationServer

  def start_link() do
    IO.puts("Starting Association Cache.")

    DynamicSupervisor.start_link(
      name: __MODULE__,
      strategy: :one_for_one
    )
  end

  def server_process(association_id) do
    case existing_process(association_id) || new_process(association_id) do
      {:error, message} ->
        {:error, message}

      pid ->
        {:ok, pid}
    end
  end

  defp existing_process(association_id) do
    AssociationServer.whereis(association_id)
  end

  defp new_process(association_id) do
    case DynamicSupervisor.start_child(
           __MODULE__,
           {AssociationServer, association_id}
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
