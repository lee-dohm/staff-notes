defmodule StaffNotesWeb.UserViewTest do
  use StaffNotesWeb.ConnCase
  use Phoenix.HTML

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

      assert content =~ context.user.name
    end
  end
end
