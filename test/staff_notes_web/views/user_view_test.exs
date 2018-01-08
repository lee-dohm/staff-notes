defmodule StaffNotesWeb.UserViewTest do
  use StaffNotesWeb.ConnCase
  use Phoenix.HTML

  alias StaffNotes.Accounts
  alias StaffNotes.Ecto.Slug
  alias StaffNotesWeb.UserView

  import Phoenix.View
  import StaffNotes.Support.Helpers

  def staff_badge(user, options \\ []) do
    user
    |> UserView.staff_badge(options)
    |> safe_to_string()
  end

  describe "staff_badge/2" do
    test "renders nothing when a non-staff user is given" do
      assert staff_badge(%{site_admin: false}) == ""
    end

    test "renders the badge when staff user is given" do
      assert staff_badge(%{site_admin: true}) =~ "Staff"
    end

    test "includes the options on the span tag" do
      assert staff_badge(%{site_admin: true}, foo: "bar") =~ ~s(<span foo="bar">)
    end
  end

  describe "user block" do
    setup do
      {
        :ok,
        user: user_fixture()
      }
    end

    test "displays the user's avatar", context do
      content = render_to_string(UserView, "show.html", conn: context.conn, user: context.user)

      assert content =~ ~s(<img class="avatar")
    end

    test "displays the user's name", context do
      content = render_to_string(UserView, "show.html", conn: context.conn, user: context.user)

      assert content =~ to_string(context.user.name)
    end
  end

  describe "organization block" do
    setup do
      {
        :ok,
        user: user_fixture()
      }
    end

    test "displays the blankslate when not a member of any organizations", context do
      content = render_to_string(UserView, "show.html", conn: context.conn, user: context.user)

      assert content =~ escape(~s(You don't belong to any organizations))
      assert content =~ ~s(Click here to create one)
    end

    test "displays the organization name if a member of one", context do
      org = org_fixture()
      {:ok, _} = Accounts.add_user_to_org(context.user, org)

      content = render_to_string(UserView, "show.html", conn: context.conn, user: context.user)

      assert content =~ Slug.to_string(org.name)
    end
  end
end
