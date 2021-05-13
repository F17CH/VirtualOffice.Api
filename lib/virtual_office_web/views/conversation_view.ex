defmodule VirtualOfficeWeb.ConversationView do
  use VirtualOfficeWeb, :view

  alias VirtualOfficeWeb.ConversationView
  alias VirtualOfficeWeb.UserView

  def render("get_conversation.json", %{conversation: conversation}) do
    %{data: conversation}
  end

  def render("individual_conversation_user.json", %{conversation: individual_conversation}) do
    IO.inspect(individual_conversation)
    IO.puts("HELLO")

    [{key, value}] = Map.to_list(individual_conversation)

    %{
      key =>
        render_one(value, ConversationView, "individual_conversation.json",
          as: :individual_conversation
        )
    }
  end

  def render("individual_conversation.json", %{
        conversation: individual_conversation
      }) do
     %{
       id: individual_conversation.id,
       recipient_user:
         render_one(individual_conversation.recipient_user, UserView, "user_from_member.json", as: :user),
       messages: individual_conversation.messages
     }
  end
end
