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
    association_ids =
      Repo.all(
        from a in Association,
          join: m in assoc(a, :members),
          join: u in assoc(m, :user),
          where: u.id == ^user_id,
          select: a.id
      )

    from(
      a in Association,
      where: a.id in ^association_ids
    )
    |> Repo.all()
    |> Repo.preload(members: :user)
  end
end
