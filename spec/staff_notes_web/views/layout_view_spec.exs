defmodule StaffNotesWeb.LayoutViewSpec do
  use ESpec.Phoenix, async: true, view: LayoutView
  use Phoenix.HTML

  alias StaffNotesWeb.LayoutView

  describe "render_flash/1" do
    def render(flash) do
      flash
      |> LayoutView.render_flash()
      |> safe_to_string()
    end

    it "returns an empty string when given no flash information" do
      expect(render(%{})).to eq("")
    end

    it "returns an empty string when given nil" do
      expect(render(nil)).to eq("")
    end

    it "returns the info flash when given only info flash information" do
      expect(render(%{info: "foo"})).to eq("<p class=\"flash\" role=\"alert\">foo</p>")
    end

    it "returns the error flash when given only error flash information" do
      expect(render(%{error: "foo"})).to eq("<p class=\"flash flash-error\" role=\"alert\">foo</p>")
    end

    it "returns both error and info flash when given both" do
      content = render(%{info: "foo", error: "bar"})

      expect(content).to eq("<p class=\"flash\" role=\"alert\">foo</p><p class=\"flash flash-error\" role=\"alert\">bar</p>")
    end
  end
end
