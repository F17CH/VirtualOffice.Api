defmodule VirtualOfficeWeb.ConversationController do
  use VirtualOfficeWeb, :controller

  alias VirtualOffice.Communication

  alias VirtualOfficeWeb.UserSpeaker

  alias VirtualOffice.Guardian

  action_fallback VirtualOfficeWeb.FallbackController

  def create_individual(conn, %{"user_id" => recipient_user_id}) do
    current_user_id = Guardian.Plug.current_resource(conn)

    new_conversation =
      Communication.create_indivdual_conversation(current_user_id, recipient_user_id)

    UserSpeaker.speak(
      {:conversation_new, new_conversation},
      [recipient_user_id]
    )

    render(conn, "get_conversation.json", conversation: new_conversation)
  end

  def get_individual(conn, %{"user_id" => recipient_user_id}) do
    current_user_id = Guardian.Plug.current_resource(conn)
    conversation = Communication.get_individual_conversation(current_user_id, recipient_user_id)

    render(conn, "get_conversation.json", conversation: conversation)
  end

  def get(conn, %{"conversation_id" => conversation_id}) do
    conversation = Communication.get_conversation(conversation_id)

    render(conn, "get_conversation.json", conversation: conversation)
  end

#  def create(conn, %{"user_ids" => user_ids = [_ | _]}) do
#    current_user_id = Guardian.Plug.current_resource(conn)
#
#    {:ok, conversation_server} = ConversationCache.create_conversation()
#
#    ConversationServer.add_user(conversation_server, current_user_id)
#
#    Enum.each(
#      user_ids,
#      fn additional_user_id ->
#        additional_user = Account.get_user!(additional_user_id)
#        ConversationServer.add_user(conversation_server, additional_user.id)
#      end
#    )
#
#    new_conversation = ConversationServer.get_conversation(conversation_server)
#
#    additional_user_ids =
#      ConversationServer.get_users(conversation_server)
#      |> List.delete(current_user_id)
#
#    UserSpeaker.speak(
#      {:conversation_new, new_conversation},
#      additional_user_ids
#    )
#
#    render(conn, "get_conversation.json", conversation: new_conversation)
#  end
end
