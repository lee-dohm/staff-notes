defmodule StaffNotes.MarkdownSpec do
  use ESpec, async: true

  alias StaffNotes.Markdown

  describe "to_html/1" do
    it "renders HTML unchanged" do
      expect(Markdown.to_html(%Markdown{html: "<p>foo</p>"})).to eq("<p>foo</p>")
    end

    it "renders a Markdown struct that hasn't been rendered yet" do
      expect(Markdown.to_html(%Markdown{text: "# Foo"})).to match("<h1>Foo</h1>")
    end

    it "renders text as Markdown" do
      expect(Markdown.to_html("# Foo")).to match("<h1>Foo</h1>")
    end

    it "renders anything else as the empty string" do
      expect(Markdown.to_html(7)).to eq("")
    end
  end

  describe "Phoenix.HTML.Safe" do
    it "implements the protocol" do
      expect(Phoenix.HTML.Safe.to_iodata(%Markdown{text: "# Foo"})).to match("<h1>Foo</h1>")
    end
  end
end
