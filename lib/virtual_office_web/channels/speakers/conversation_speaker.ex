defmodule VirtualOfficeWeb.ConversationSpeaker do
  alias VirtualOffice.Communication.Message

  alias VirtualOfficeWeb.MessageView

  def speak({:message_new, message = %Message{}}, conversation_id) do
    VirtualOfficeWeb.Endpoint.broadcast!(
      "conversation:" <> conversation_id,
      "message_new",
      Phoenix.View.render(MessageView, "get_message.json", message: message)
    )
  end
end
