defmodule VirtualOffice.InstantMessage.ConversationRegistry do

  def start_link() do
    IO.puts("Starting Conversation Registry.")

    Registry.start_link(keys: :unique, name: __MODULE__)
  end

  def via_tuple(key) do
    {:via, Registry, {__MODULE__, key}}
  end

  def look_up(key) do

  end

  def child_spec(_) do
    Supervisor.child_spec(
      Registry,
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    )
  end
end
