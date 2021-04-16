defmodule VirtualOfficeWeb.Group.Association do
  use VirtualOfficeWeb, :controller

  alias VirtualOffice.Account.User

  action_fallback VirtualOfficeWeb.FallbackController


  def index(conn, _params) do
    users = Account.list_users()
    render(conn, "index.json", users: users)
  end

  alias VirtualOffice.Guardian

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Account.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> render("jwt.json", jwt: token)
    end
  end

  def self(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    conn
    |> render("show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Account.get_user!(id)

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(id)

    with {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Account.token_sign_in(email, password) do
      {{:ok, token, _claims}, tokenSeconds} ->
        conn
        |> render("jwt.json", token: token, expires_in: tokenSeconds)
        _ ->
      {:error, :unauthorized}
    end
  end

  def sign_out(conn, _params) do
    token = Guardian.Plug.current_token(conn)
    Guardian.revoke(token)
    conn
    |> send_resp(:no_content, "")
  end

  def health(conn, _params) do
    _ = Guardian.Plug.current_resource(conn)
    conn
    |> send_resp(:no_content, "")
  end
end
