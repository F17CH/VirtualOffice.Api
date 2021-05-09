defmodule VirtualOfficeWeb.AssociationView do
  use VirtualOfficeWeb, :view

  alias VirtualOffice.Group.Association
  alias VirtualOffice.Group.Member
  alias VirtualOfficeWeb.AssociationView
  alias VirtualOfficeWeb.UserView

  def render("get_associations.json", %{associations: associations}) do
    %{data: render_many(associations, AssociationView, "association.json")}
  end

  def render("get_association.json", %{association: association}) do
    %{data: render_one(association, AssociationView, "association.json")}
  end

  def render("association.json", %{association: association = %Association{}}) do
    %{id: association.id, name: association.name, members: render_many(association.members, AssociationView, "member_from_association.json", as: :member)}
  end

  def render("member_from_association.json", %{member: member = %Member{}}) do
    %{role: member.role, user: render_one(member.user, UserView, "user_from_member.json")}
  end
end
