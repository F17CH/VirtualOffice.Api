defmodule VirtualOffice.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias VirtualOffice.Repo

  alias VirtualOffice.Account.User

  alias VirtualOffice.Guardian

  @tokenSeconds 18000000000


  def list_users do
    Repo.all(User)
  end


  def get_user!(id), do: Repo.get!(User, id)


  def create_user(attrs \\ %{}) do
    IO.inspect(attrs)

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end


  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def token_sign_in(email, password) do
    case email_password_auth(email, password) do
      {:ok, user} ->
        {Guardian.encode_and_sign(user, %{}, ttl: {@tokenSeconds, :seconds}), @tokenSeconds}
        _ ->
          {:error, :unauthorized}
    end
  end

  def token_sign_in(user) do
        {Guardian.encode_and_sign(user, %{}, ttl: {@tokenSeconds, :seconds}), @tokenSeconds}
  end

  defp email_password_auth(email, password) when is_binary(email) and is_binary(password) do
    with {:ok, user} <- get_by_email(email),
    do: verify_password(password, user)
  end

  defp get_by_email(email) when is_binary(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        verify_password(nil)
        {:error, "Login Error"}
      user ->
        {:ok, user}
      end
  end

  defp verify_password(nil) do
    Pbkdf2.no_user_verify()
    {:error, "Wrong email or password"}
  end

  defp verify_password(password, %User{} = user) do
    if Pbkdf2.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :invalid_password}
    end
  end
end
