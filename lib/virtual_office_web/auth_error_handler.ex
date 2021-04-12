defmodule VirtualOffice.AuthErrorHandler do
  @behaviour Guardian.Plug.ErrorHandler

  import Plug.Conn

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    conn = put_resp_content_type(conn, "application/json")

    case type do
      :unauthenticated ->
        send_resp(conn, 401, Phoenix.View.render_to_string(VirtualOfficeWeb.ErrorView, "error.json", code: 401, details: "Unauthorized Request"))
      :invalid_token ->
        send_resp(conn, 401, Phoenix.View.render_to_string(VirtualOfficeWeb.ErrorView, "error.json", code: 401, details: "Invalid Token"))
      _ ->
        send_resp(conn, 400, Phoenix.View.render_to_string(VirtualOfficeWeb.ErrorView, "error.json", code: 400, details: to_string(type)))
    end
  end
end
