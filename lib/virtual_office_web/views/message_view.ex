defmodule VirtualOfficeWeb.MessageView do
  use VirtualOfficeWeb, :view

  def render("messages.json", %{messages: messages}) do
    %{data: messages}
  end

  def render("message.json", %{message: message}) do
    %{data: message}
  end
end
