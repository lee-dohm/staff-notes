defmodule StaffNotesWeb.ErrorViewTest do
  use StaffNotesWeb.ConnCase

  alias StaffNotesWeb.ErrorView

  import Phoenix.View

  describe "404.html" do
    test "returns page not found", context do
      content = render_to_string(ErrorView, "404.html", conn: context.conn)

      assert content =~ "Page not found"
    end
  end

  describe "500.html" do
    test "returns internal server error", context do
      content = render_to_string(ErrorView, "500.html", conn: context.conn)

      assert content =~ "Internal server error"
    end
  end

  describe "any other" do
    test "returns internal server error", context do
      content = render_to_string(ErrorView, "505.html", conn: context.conn)

      assert content =~ "Internal server error"
    end
  end
end
