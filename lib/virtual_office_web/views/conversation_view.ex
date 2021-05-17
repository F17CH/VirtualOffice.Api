defmodule VirtualOfficeWeb.ConversationView do
  use VirtualOfficeWeb, :view

  alias VirtualOfficeWeb.ConversationView
  alias VirtualOfficeWeb.MessageView
  alias VirtualOfficeWeb.UserView

  alias VirtualOffice.Communication.Conversation

  def render("get_conversation.json", %{conversation: conversation = %Conversation{}}) do
    %{data: render_one(conversation, ConversationView, "conversation.json")}
  end

  def render("conversation.json", %{
    conversation: conversation = %Conversation{}
  }) do
    %{
    id: conversation.id,
    individual: conversation.individual,
    messages: render_many(conversation.messages, MessageView, "message_from_conversation.json", as: :message),
    users: render_many(conversation.conversation_users, UserView, "conversation_user_from_conversation.json", as: :conversation_user)
    }
  end

  def render("individual_conversation.json", %{
        conversation: individual_conversation
      }) do
     %{
       id: individual_conversation.id,
       recipientUser:
         render_one(individual_conversation.recipient_user, UserView, "user_from_member.json", as: :user),
       messages: individual_conversation.messages
     }
  end


end
