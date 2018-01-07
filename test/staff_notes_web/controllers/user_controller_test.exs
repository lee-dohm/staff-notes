defmodule StaffNotesWeb.UserControllerTest do
  use StaffNotesWeb.ConnCase

  import StaffNotes.Support.Helpers

  describe "GET show" do
    setup [:setup_regular_user]

    test "a user that exists returns ok", context do
      conn = get(context.conn, user_path(context.conn, :show, context.regular_user))

      assert html_response(conn, :ok)
      assert conn.assigns.user == context.regular_user
      assert rendered?(conn, "show.html")
    end

    test "a user that doesn't exist returns not found", context do
      conn = get(context.conn, user_path(context.conn, :show, "user-that-does-not-exist"))

      assert html_response(conn, :not_found)
      assert error_rendered?(conn, :not_found)
      refute conn.assigns[:user]
    end
  end
end
