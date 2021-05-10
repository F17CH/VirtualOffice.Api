defmodule VirtualOfficeWeb.ConversationSpeaker do
  alias VirtualOffice.Communication.Message

  def speak({:message_new, message = %Message{}}, conversation_id) do
    VirtualOfficeWeb.Endpoint.broadcast!("conversation:" <> conversation_id, "message_new", %{
      data: message
    })
  end
end
