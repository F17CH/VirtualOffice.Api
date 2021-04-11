defmodule VirtualOfficeWeb.ConversationView do
  use VirtualOfficeWeb, :view

  def render("get_conversation.json", %{conversation: conversation}) do
    %{conversation: conversation}
  end
end
