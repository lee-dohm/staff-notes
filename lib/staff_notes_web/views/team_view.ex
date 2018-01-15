defmodule StaffNotesWeb.TeamView do
  @moduledoc """
  View functions for `StaffNotes.Accounts.Team` templates.
  """
  use StaffNotesWeb, :view

  def render_team_info_list(conn, teams) do
    render_many(teams, __MODULE__, "team_info_item.html", conn: conn)
  end
end
