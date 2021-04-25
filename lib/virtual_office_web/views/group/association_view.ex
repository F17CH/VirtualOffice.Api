defmodule VirtualOfficeWeb.AssociationView do
  use VirtualOfficeWeb, :view

  def render("get_association.json", %{association: association}) do
    %{data: association}
  end
end
