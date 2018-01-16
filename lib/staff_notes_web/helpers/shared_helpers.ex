defmodule StaffNotesWeb.SharedHelpers do
  @moduledoc """
  Helper functions for rendering shared templates.
  """
  use StaffNotesWeb, :helper

  alias Phoenix.View
  alias StaffNotesWeb.SharedView

  @doc """
  Renders a shared template.
  """
  def render_shared(template, assigns) do
    View.render(SharedView, template, assigns)
  end
end
