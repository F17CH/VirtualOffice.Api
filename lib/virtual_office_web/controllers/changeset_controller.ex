defmodule VirtualOfficeWeb.ChangesetController do
  alias Ecto.Changeset

  use VirtualOfficeWeb, :controller

  def display_changeset_error(conn, %Changeset{} = changeset) do
    {field, {_msg, error}} = List.first(changeset.errors)

    message = case error do
      [constraint: :unique, constraint_name: _msg] ->
        Macro.camelize((Atom.to_string(field))) <> " must be unique."
        [validation: :format] ->
          "Invalid " <> Macro.camelize((Atom.to_string(field))) <> "."
        _ -> "Invalid Entity."
    end

    conn
    |> put_status(:unprocessable_entity)
    |> put_view(VirtualOfficeWeb.ErrorView)
    |> render("error.json", %{code: 422, details: message})
  end
end
