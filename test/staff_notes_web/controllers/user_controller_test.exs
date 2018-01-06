defmodule StaffNotesWeb.UserControllerTest do
  use StaffNotesWeb.ConnCase

  import StaffNotes.Support.Helpers

  describe "GET show" do
    setup [:setup_regular_user]

    test "a user that exists returns ok", context do
      conn =
        context.conn
        |> get(user_path(context.conn, :show, context.regular_user.name))

      assert html_response(conn, :ok)
      assert conn.assigns.user == context.regular_user
    end

    test "a user that doesn't exist returns not found", context do
      conn =
        context.conn
        |> get(user_path(context.conn, :show, "user that doesn't exist"))

      assert html_response(conn, :not_found)
      refute conn.assigns[:user]
    end
  end
end
