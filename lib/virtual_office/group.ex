defmodule VirtualOffice.Group do
  alias VirtualOffice.Group.Association
  alias VirtualOffice.Group.AssociationCache
  alias VirtualOffice.Group.AssociationServer

  alias VirtualOffice.Group.Member

  def create_association(attrs \\ %{}) do
    Association.new(attrs)
  end

  def join_association(association_id, user_id, role) do
    {:ok, association_server} = AssociationCache.server_process(association_id)
    AssociationServer.join_association(association_server, user_id, role)
  end

  def create_member(attrs \\ %{}) do
    Member.new(attrs)
  end

  def get_association(association_id) do
    {:ok, association_server} = AssociationCache.server_process(association_id)
    AssociationServer.get_association(association_server)
  end

end
