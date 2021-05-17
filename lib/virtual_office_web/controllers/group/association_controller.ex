defmodule VirtualOfficeWeb.AssociationController do
  use VirtualOfficeWeb, :controller

  alias VirtualOffice.Group
  alias VirtualOffice.Group.Association

  action_fallback VirtualOfficeWeb.FallbackController

  def create(conn, %{"name" => name}) do
    current_user_id = Guardian.Plug.current_resource(conn)

    case Group.create_association(%{name: name}) do
      {:ok, %Association{} = association} ->
        association = Group.join_association(association.id, current_user_id, "Owner")

        render(conn, "get_association.json", association: association)
    end
  end

  def get(conn, %{"association_id" => association_id}) do
    render(conn, "get_association.json", association: Group.get_association(association_id))
  end

  def join(conn, %{"association_id" => association_id, "role" => role}) do
    current_user_id = Guardian.Plug.current_resource(conn)

    association = Group.join_association(association_id, current_user_id, role)

    render(conn, "get_association.json", association: association)
  end
end
