defmodule VirtualOfficeWeb.MessageController do
  use VirtualOfficeWeb, :controller

  alias VirtualOffice.InstantMessage
  alias VirtualOffice.InstantMessage.ConversationServer
  alias VirtualOffice.InstantMessage.ConversationCache

  alias VirtualOffice.Account
  alias VirtualOffice.Account.User

  alias VirtualOffice.Guardian

  action_fallback VirtualOfficeWeb.FallbackController

  def create(conn, %{"conversation_id" => conversation_id, "content" => message_content}) do
    user = Guardian.Plug.current_resource(conn)

    ConversationCache.get_conversation(conversation_id)
    |> ConversationServer.add_message(user.id, message_content)

    conn
    |> send_resp(:no_content, "")
  end

  def get_all(conn, %{"conversation_id" => conversation_id}) do

    messages = ConversationCache.get_conversation(conversation_id)
    |> ConversationServer.get_messages()

    render(conn, "messages.json", messages: messages)
  end

end
