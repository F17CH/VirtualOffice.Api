defmodule VirtualOffice.Group do
  alias VirtualOffice.Group.Association
  alias VirtualOffice.Group.AssociationCache
  alias VirtualOffice.Group.AssociationServer

  def create_association(attrs \\ %{}) do
    Association.new(attrs)
  end

  def get_association(association_id) do
    association_Server = AssociationCache.server_process(association_id)
    AssociationServer.get_association(association_Server)
  end

end
