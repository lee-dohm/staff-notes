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

    test "a user that doesn't exist raises NoResultsError", context do
      assert_raise Ecto.NoResultsError, fn ->
        get(context.conn, user_path(context.conn, :show, "user-that-does-not-exist"))
      end
    end
  end
end
