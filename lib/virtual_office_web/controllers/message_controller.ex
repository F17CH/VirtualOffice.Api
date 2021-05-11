defmodule VirtualOfficeWeb.MessageController do
  use VirtualOfficeWeb, :controller

  alias VirtualOffice.Communication
  alias VirtualOffice.Communication
  alias VirtualOffice.Guardian

  alias VirtualOfficeWeb.ConversationSpeaker

  action_fallback VirtualOfficeWeb.FallbackController

  def create(conn, %{"conversation_id" => conversation_id, "content" => message_content}) do
    current_user_id = Guardian.Plug.current_resource(conn)

    case Communication.add_message(conversation_id, current_user_id, message_content) do
      {:ok, message} ->
        ConversationSpeaker.speak({:message_new, message}, conversation_id)

        render(conn, "message.json", message: message)
    end
  end

  def get_all(conn, %{"conversation_id" => conversation_id}) do

    messages = ConversationCache.get_conversation(conversation_id)
    |> ConversationServer.get_messages()

    render(conn, "messages.json", messages: messages)
  end

end
