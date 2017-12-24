defmodule StaffNotesWeb.UserView do
  @moduledoc """
  View functions for the user pages.
  """
  use StaffNotesWeb, :view

  @doc """
  Displays a staff badge if the given user is a site admin.
  """
  def staff_badge(%{site_admin: true}, options), do: content_tag(:span, gettext("Staff"), options)
  def staff_badge(_, _), do: ""
end
