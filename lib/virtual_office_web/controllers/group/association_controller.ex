defmodule VirtualOfficeWeb.AssociationController do
  use VirtualOfficeWeb, :controller

  alias VirtualOffice.Group
  alias VirtualOffice.Group.Association

  action_fallback VirtualOfficeWeb.FallbackController

  def create(conn, %{"association" => association_params}) do
    case Group.create_association(association_params) do
      {:ok, %Association{} = association} ->
        render(conn, "get_association.json", association: association)
    end
  end

  def get(conn, %{"association_id" => association_id}) do
  render(conn, "get_association.json", association: Group.get_association(association_id))
  end
end
