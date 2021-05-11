defmodule VirtualOfficeWeb.UserView do
  use VirtualOfficeWeb, :view
  alias VirtualOfficeWeb.UserView
  alias VirtualOfficeWeb.AssociationView
  alias VirtualOfficeWeb.ConversationView

  def render("get_users.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("get_user.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, email: user.email, firstName: user.first_name, lastName: user.last_name}
  end

  def render("user_from_member.json", %{user: user}) do
    %{id: user.id, firstName: user.first_name, lastName: user.last_name}
  end

  def render("user_with_associations_and_conversations.json", %{
        user: user,
        associations: associations,
        individual_conversations: individual_conversations
      }) do
    %{
      data: %{
        id: user.id,
        email: user.email,
        firstName: user.first_name,
        lastName: user.last_name,
        associations: render_many(associations, AssociationView, "association.json"),
        individual_conversations: render_many(individual_conversations, ConversationView, "individual_conversation.json")
      }
    }
  end

  def render("user_from_sign_in.json", %{user: user}) do
    %{
      data: %{
        user: %{
          id: user.id,
          email: user.email
        }
      }
    }
  end

  def render("jwt.json", %{token: token, expires_in: expires_in}) do
    %{data: %{token: token, expires_in: expires_in}}
  end
end
