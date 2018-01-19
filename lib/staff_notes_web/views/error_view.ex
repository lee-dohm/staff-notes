defmodule StaffNotesWeb.ErrorView do
  @moduledoc """
  Displays error pages.
  """
  use StaffNotesWeb, :view

  @doc """
  Called when no render clause matches or the template for a render clause is not found.
  """
  @spec template_not_found(Phoenix.Template.name(), Map.t()) :: no_return
  def template_not_found(_template, assigns) do
    render("500.html", assigns)
  end
end
