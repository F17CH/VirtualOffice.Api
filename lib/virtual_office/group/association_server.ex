defmodule VirtualOffice.Group.AssociationServer do
  use GenServer, restart: :temporary

  alias VirtualOffice.Group.AssociationServer
  alias VirtualOffice.Group.Association

  @association_timeout_ms 600000

  def start_link(association_id) do
    IO.puts("Starting GenServer for Association: #{association_id}")

    GenServer.start_link(AssociationServer, association_id, name: global_name(association_id))
  end

  def get_association(association_server) do
    GenServer.call(association_server, {:get_association})
  end

  def join_association(association_server, user_id, role) do
    GenServer.call(association_server, {:join_association, user_id, role})
  end

  @impl GenServer
  def init(association_id) do
    case Association.load_association(association_id) do
      :nil -> {:stop, {:shutdown, :invalid_association}}
      association -> {:ok, association, @association_timeout_ms}
    end
  end

  @impl GenServer
  def handle_info(:timeout, association) do
    {:stop, :normal, association}
  end

  @impl GenServer
  def terminate(:normal, association) do
    IO.puts("Stopping GenServer for Assocation: #{association.id}")
  end

  @impl GenServer
  def handle_call({:get_association}, _, association) do
    {:reply, Association.get_association(association), association, @association_timeout_ms}
  end

  @impl GenServer
  def handle_call({:join_association, user_id, role}, _, association) do
    new_association = Association.join_association(association, user_id, role)

    {:reply, new_association, new_association, @association_timeout_ms}
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
