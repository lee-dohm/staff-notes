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
  def create_org_button do
    link(gettext("Create organization"), to: "#", class: "btn btn-primary", type: "button")
  end

  @doc """
  Render the organizations the given user belongs to.
  """
  def render_user_orgs(user) do
    user = Repo.preload(user, :organizations)

    do_render_user_orgs(user.organizations)
  end

  defp do_render_user_orgs(orgs) when length(orgs) == 0 do
    render(__MODULE__, "orgs_blankslate.html")
  end

  defp do_render_user_orgs(orgs) do
    render_many(orgs, __MODULE__, "show_org.html", as: :org)
  end

  @doc """
  Displays a staff badge if the given user is a site admin.
  """
  @spec staff_badge(User.t, Keyword.t) :: Phoenix.HTML.safe
  def staff_badge(user, options)
  def staff_badge(%{site_admin: true}, options), do: content_tag(:span, gettext("Staff"), options)
  def staff_badge(_, _), do: {:safe, ""}
end
