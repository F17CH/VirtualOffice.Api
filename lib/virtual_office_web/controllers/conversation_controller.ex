defmodule VirtualOfficeWeb.ConversationController do
  use VirtualOfficeWeb, :controller

  alias VirtualOffice.InstantMessage.ConversationServer
  alias VirtualOffice.InstantMessage.ConversationCache

  alias VirtualOffice.Account
  alias VirtualOfficeWeb.UserSpeaker

  alias VirtualOffice.Guardian

  action_fallback VirtualOfficeWeb.FallbackController

  def create(conn, %{"user_ids" => user_ids = [_ | _]}) do
    user = Guardian.Plug.current_resource(conn)

    {:ok, conversation_server} = ConversationCache.create_conversation()

    ConversationServer.add_user(conversation_server, user.id)

    Enum.each(
      user_ids,
      fn additional_user_id ->
        additional_user = Account.get_user!(additional_user_id)
        ConversationServer.add_user(conversation_server, additional_user.id)
      end
    )

    new_conversation = ConversationServer.get_conversation(conversation_server)

    additional_user_ids =
      ConversationServer.get_users(conversation_server)
      |> List.delete(user.id)

    UserSpeaker.speak(
      {:conversation_new, new_conversation},
      additional_user_ids
    )

    render(conn, "get_conversation.json", conversation: new_conversation)
  end

  def get(conn, %{"conversation_id" => conversation_id}) do
    conv = ConversationCache.get_conversation(conversation_id)

    render(conn, "get_conversation.json", conversation: ConversationServer.get_conversation(conv))
  end
end
