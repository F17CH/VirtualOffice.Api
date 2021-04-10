defmodule VirtualOfficeWeb.ConversationView do
  use VirtualOfficeWeb, :view

  def render("create.json", %{conversation_id: conversation_id}) do
    %{id: conversation_id}
  end
end
