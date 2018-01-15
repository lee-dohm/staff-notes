defmodule StaffNotesWeb.StaffView do
  @moduledoc """
  View functions for displaying `StaffNotes.Accounts.User` records as part of an organization.
  """
  use StaffNotesWeb, :view

  def render_staff_info_list(conn, users) do
    render_many(users, __MODULE__, "staff_info_item.html", conn: conn, as: :user)
  end
end
