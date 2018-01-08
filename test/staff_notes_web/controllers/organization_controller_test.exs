defmodule StaffNotesWeb.OrganizationControllerTest do
  use StaffNotesWeb.ConnCase

  import StaffNotes.Support.Helpers

  describe "GET show" do
    setup [:setup_regular_org]

    test "an org that exists returns ok", context do
      conn = get(context.conn, organization_path(context.conn, :show, context.regular_org))

      assert html_response(conn, :ok)
      assert conn.assigns.org.id == context.regular_org.id
      assert rendered?(conn, "show.html")
    end

    test "an org that does not exist returns an error", context do
      conn = get(context.conn, organization_path(context.conn, :show, "org-that-does-not-exist"))

      assert html_response(conn, :not_found)
      assert error_rendered?(conn, :not_found)
      refute conn.assigns[:org]
    end
  end
end
