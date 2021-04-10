defmodule VirtualOfficeWeb.ConversationController do
  use VirtualOfficeWeb, :controller

  alias VirtualOffice.InstantMessage
  alias VirtualOffice.InstantMessage.ConversationServer
  alias VirtualOffice.InstantMessage.ConversationCache

  alias VirtualOffice.Account
  alias VirtualOffice.Account.User

  alias VirtualOffice.Guardian

  action_fallback VirtualOfficeWeb.FallbackController

  def create(conn, %{"user_ids" => user_ids = [_ | _]}) do


    :observer.start()

    user = Guardian.Plug.current_resource(conn)

    {:ok, new_conversation_id, conv} = ConversationCache.create_conversation()
    ConversationServer.add_user(conv, user)

    Enum.each(
      user_ids,
      fn additional_user_id ->
        additional_user = Account.get_user!(additional_user_id)
        ConversationServer.add_user(conv, additional_user)
      end
      )

      render(conn, "create.json", conversation_id: new_conversation_id)

  end


end
