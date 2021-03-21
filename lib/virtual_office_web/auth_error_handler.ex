defmodule VirtualOffice.AuthErrorHandler do
  @behaviour Guardian.Plug.ErrorHandler

  import Plug.Conn

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    conn = put_resp_content_type(conn, "application/json")

    case type do
      :unauthenticated ->
        body = Jason.encode!(%{status: 401, message: "Unauthorized"})
        send_resp(conn, 401, body)
      :invalid_token ->
        body = Jason.encode!(%{status: 401, message: "Invalid Token"})
        send_resp(conn, 401, body)
      _ ->
        body = Jason.encode!(%{status: 400, message: to_string(type)})
        send_resp(conn, 400, body)
    end
  end
end
