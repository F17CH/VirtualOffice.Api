defmodule VirtualOffice.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :virtual_office,
  module: VirtualOffice.Guardian,
  error_handler: VirtualOffice.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
