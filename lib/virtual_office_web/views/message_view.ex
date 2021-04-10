defmodule VirtualOfficeWeb.MessageView do
  use VirtualOfficeWeb, :view

  def render("messages.json", %{messages: messages}) do
    %{messages: messages}
  end
end
