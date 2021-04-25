defmodule VirtualOffice.Group.AssociationServer do
  use GenServer, restart: :temporary

  alias VirtualOffice.Group.AssociationServer
  alias VirtualOffice.Group.Association

  def start_link(association_id) do
    IO.puts("Starting GenServer for Association: #{association_id}")

    GenServer.start_link(AssociationServer, association_id, name: global_name(association_id))
  end

  def get_association(association_server) do
    GenServer.call(association_server, {:get_association})
  end

  @impl GenServer
  def init(association_id) do
    {:ok, Association.load_association(association_id)}
  end

  @impl GenServer
  def handle_call({:get_association}, _, association) do
    {:reply, Association.get_association(association), association}
  end

  def whereis(association_id) do
    case :global.whereis_name({__MODULE__, association_id}) do
      :undefined -> nil
      pid -> pid
    end
  end

  defp global_name(association_id) do
    {:global, {__MODULE__, association_id}}
  end

end
