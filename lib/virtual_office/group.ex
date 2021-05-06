defmodule VirtualOffice.Group do
  alias VirtualOffice.Group.Association
  alias VirtualOffice.Group.AssociationCache
  alias VirtualOffice.Group.AssociationServer

  alias VirtualOffice.Group.Member

  import Ecto.Query, warn: false
  alias VirtualOffice.Repo

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

  def get_associations_for_user(user_id) do
    Repo.all(
      from a in Association,
      join: m in Member,
      on: a.id == m.association_id,
      where: m.user_id == ^user_id
    ) |> Repo.preload(:members)
  end

end
