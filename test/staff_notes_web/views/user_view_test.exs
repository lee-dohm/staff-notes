defmodule StaffNotesWeb.UserViewTest do
  use ExUnit.Case
  use Phoenix.HTML

  alias StaffNotesWeb.UserView

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
end
