defmodule VirtualOfficeWeb.UserChannel do
  use VirtualOfficeWeb, :channel

  def join("user:" <> _user_id, _payload, socket) do
    {:ok, socket}
  end

  def handle_in("hello", payload, socket) do
    push socket, "said_hello", payload
    {:noreply, socket}
  end

end
