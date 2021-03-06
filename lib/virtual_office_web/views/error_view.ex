defmodule VirtualOfficeWeb.ErrorView do
  use VirtualOfficeWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    render("error.json", %{code: get_status_code(template), details: Phoenix.Controller.status_message_from_template(template)})
  end

  def render("error.json", %{code: code, details: details}) do
    %{
      error: %{
        code: code,
        details: details
      }
    }
  end

  defp get_status_code(template) do
    template
    |> String.split(".")
    |> hd()
    |> String.to_integer()
  end
end
