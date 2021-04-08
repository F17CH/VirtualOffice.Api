defmodule VirtualOfficeWeb.ConversationController do
  use VirtualOfficeWeb, :controller

  alias VirtualOffice.InstantMessage
  alias VirtualOffice.InstantMessage.ConversationServer

  alias VirtualOffice.Account
  alias VirtualOffice.Account.User

  alias VirtualOffice.Guardian

  action_fallback VirtualOfficeWeb.FallbackController

  def create_conversation(conn, %{"user_ids" => user_ids = [_ | _]}) do

    user = Guardian.Plug.current_resource(conn)
    {:ok, conv} = ConversationServer.start()
    ConversationServer.add_user(conv, user)

    Enum.each(
      user_ids,
      fn additional_user_id ->
        additional_user = Account.get_user!(additional_user_id)
        ConversationServer.add_user(conv, additional_user)
      end
      )

    conn
    |> send_resp(:no_content, "")
  end
end
