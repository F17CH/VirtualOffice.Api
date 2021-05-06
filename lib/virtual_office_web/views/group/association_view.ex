defmodule VirtualOfficeWeb.AssociationView do
  use VirtualOfficeWeb, :view

  alias VirtualOfficeWeb.AssociationView

  def render("get_associations.json", %{associations: associations}) do
    %{data: render_many(associations, AssociationView, "association.json")}
  end

  def render("get_association.json", %{association: association}) do
    %{data: render_one(association, AssociationView, "association.json")}
  end

  def render("association.json", %{association: association}) do
    association
  end
end
