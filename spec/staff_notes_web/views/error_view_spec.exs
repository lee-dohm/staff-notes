defmodule StaffNotesWeb.ErrorViewSpec do
  use ESpec.Phoenix, async: true, view: ErrorView


  describe "404.html" do
    let :content do
      render_to_string(StaffNotesWeb.ErrorView, "404.html", conn: build_conn())
    end

    it do: expect(content()).to have("Page not found")
  end

  describe "500.html" do
    let :content do
      render_to_string(StaffNotesWeb.ErrorView, "500.html", conn: build_conn())
    end

    it do: expect(content()).to have("Internal server error")
  end

  describe "any other" do
    let :content do
      render_to_string(StaffNotesWeb.ErrorView, "505.html", conn: build_conn())
    end

    it do: expect(content()).to have("Internal server error")
  end
end
