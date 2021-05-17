defmodule VirtualOfficeWeb.MessageView do
  use VirtualOfficeWeb, :view

  alias VirtualOfficeWeb.MessageView

  alias VirtualOffice.Communication.Message


  def render("get_message.json", %{message: message = %Message{}}) do
    %{data: render_one(message, MessageView, "message_from_conversation.json")}
  end

  def render("get_messages.json", %{messages: messages}) do
    %{data: render_many(messages, MessageView, "message_from_conversation.json")}
  end

  def render("message_from_conversation.json", %{message: message = %Message{}}) do
    %{
      id: message.message_id,
      userId: message.user_id,
      content: message.content
    }
  end
end
