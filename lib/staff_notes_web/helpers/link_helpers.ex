defmodule StaffNotesWeb.LinkHelpers do
  use StaffNotesWeb, :helper

  import StaffNotesWeb.Router.Helpers

  alias StaffNotes.Accounts.User
  alias StaffNotes.Notes.Member
  alias StaffNotes.Repo

  def member_link(conn, %Member{} = member) do
    member = Repo.preload(member, [:organization])

    link(member.name, to: organization_member_path(conn, :show, member.organization, member), class: "member-link link-gray")
  end

  def staff_link(conn, %User{} = user) do
    link(user.name, to: user_path(conn, :show, user), class: "staff-link link-gray")
  end
end
