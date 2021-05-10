defmodule VirtualOfficeWeb.UserSpeaker do

  alias VirtualOffice.Communication.Conversation

  def speak({:conversation_new, conversation = %Conversation{}}, user_ids) do
    Enum.each(
      user_ids,
      fn user_id ->
        VirtualOfficeWeb.Endpoint.broadcast!("user:" <> user_id, "conversation_new", %{
          data: conversation
        })
      end
    )
  end
end
