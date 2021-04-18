defmodule VirtualOfficeWeb.ConversationChannel do
  use VirtualOfficeWeb, :channel

  def join("conversation:" <> _conversation_id, _payload, socket) do
    {:ok, socket}
  end

  def handle_in("hello", payload, socket) do
    push socket, "said_hello", payload
    {:noreply, socket}
  end

end
