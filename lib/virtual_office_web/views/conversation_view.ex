defmodule VirtualOfficeWeb.ConversationView do
  use VirtualOfficeWeb, :view

  alias VirtualOffice.Communication.IndividualConversation
  alias VirtualOfficeWeb.UserView

  def render("get_conversation.json", %{conversation: conversation}) do
    %{data: conversation}
  end

  def render("individual_conversation_user.json", %{individual_conversation}

  def render("individual_conversation.json", %{
        individual_conversation: individual_conversation
      }) do
    %{
      id: individual_conversation.id,
      recipient_user:
        render_one(individual_conversation.recipient_user, UserView, "user_from_member.json", as: :user),
      messages: individual_conversation.messages
    }
  end
end
