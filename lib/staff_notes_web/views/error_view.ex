defmodule StaffNotesWeb.ErrorView do
  @moduledoc """
  Displays error pages.
  """
  use StaffNotesWeb, :view

  @doc """
  Renders the error template.
  """
  def render(template, assigns) do
    [status, format] = String.split(template, ".")

    do_render(status, format, assigns)
  end

  # Assume that all JSON errors are going to be exception objects with a well-formed `message`
  # property.
  defp do_render(_, "json", %{conn: conn}) do
    %{message: conn.assigns.reason.message}
  end

  # Show the boring error messages for now when HTML is accepted.
  defp do_render("404", "html", _assigns), do: "Page not found"
  defp do_render("500", "html", _assigns), do: "Internal server error"

  @doc """
  Called when no render clause matches or the template for a render clause is not found.
  """
  @spec template_not_found(Phoenix.Template.name(), Map.t()) :: no_return
  def template_not_found(_template, assigns) do
    render("500.html", assigns)
  end
end
