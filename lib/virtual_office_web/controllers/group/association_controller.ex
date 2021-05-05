defmodule VirtualOfficeWeb.AssociationController do
  use VirtualOfficeWeb, :controller

  alias VirtualOffice.Group
  alias VirtualOffice.Group.Association

  action_fallback VirtualOfficeWeb.FallbackController

  def create(conn, %{"association" => association_params}) do
    user = Guardian.Plug.current_resource(conn)

    case Group.create_association(association_params) do
      {:ok, %Association{} = association} ->
        association = Group.join_association(association.id, user.id, "Owner")

        render(conn, "get_association.json", association: association)
    end
  end

  def get(conn, %{"association_id" => association_id}) do
  render(conn, "get_association.json", association: Group.get_association(association_id))
  end
end
