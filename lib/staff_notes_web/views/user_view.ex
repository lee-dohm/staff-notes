defmodule StaffNotesWeb.UserView do
  @moduledoc """
  View functions for the user pages.
  """
  use StaffNotesWeb, :view

  alias StaffNotes.Accounts.User
  alias StaffNotes.Repo

  @doc """
  Renders a "Create organization" button.
  """
  def create_org_button(options \\ []) do
    link_options = Keyword.merge(options, to: "#", type: "button")

    link(gettext("Create organization"), link_options)
  end

  @doc """
  Renders the list of organizations the given user belongs to.
  """
  def render_org_info_list(conn, user) do
    user = Repo.preload(user, :organizations)

    do_render_org_info_list(conn, user.organizations)
  end

  defp do_render_org_info_list(conn, orgs) when length(orgs) == 0 do
    render(__MODULE__, "org_info_blankslate.html", conn: conn)
  end

  defp do_render_org_info_list(conn, orgs) do
    render_many(orgs, __MODULE__, "org_info_item.html", conn: conn, as: :org)
  end

  @doc """
  Creates a link to the given organization's show page.
  """
  def show_org_link(conn, org) do
    link(org.name, to: organization_path(conn, :show, org))
  end

  @doc """
  Displays a staff badge if the given user is a site admin.
  """
  @spec staff_badge(User.t, Keyword.t) :: Phoenix.HTML.safe
  def staff_badge(user, options)
  def staff_badge(%{site_admin: true}, options), do: content_tag(:span, gettext("Staff"), options)
  def staff_badge(_, _), do: {:safe, ""}
end
