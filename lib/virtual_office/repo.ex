defmodule VirtualOffice.Repo do
  use Ecto.Repo,
    otp_app: :virtual_office,
    adapter: Ecto.Adapters.Postgres
end
