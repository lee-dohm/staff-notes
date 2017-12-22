defmodule StaffNotesWeb.ErrorViewSpec do
  use ESpec.Phoenix, async: true, view: ErrorView


  describe "404.html" do
    let :content do
      render_to_string(StaffNotesWeb.ErrorView, "404.html", conn: build_conn())
    end

    it do: expect(content()).to have("Page not found")
  end
end

# defmodule StaffNotesWeb.ErrorViewTest do
#   use StaffNotesWeb.ConnCase, async: true
#
#   # Bring render/3 and render_to_string/3 for testing custom views
#   import Phoenix.View
#
#   test "renders 404.html" do
#     assert render_to_string(StaffNotesWeb.ErrorView, "404.html", []) ==
#            "Page not found"
#   end
#
#   test "render 500.html" do
#     assert render_to_string(StaffNotesWeb.ErrorView, "500.html", []) ==
#            "Internal server error"
#   end
#
#   test "render any other" do
#     assert render_to_string(StaffNotesWeb.ErrorView, "505.html", []) ==
#            "Internal server error"
#   end
# end
