defmodule StaffNotes.Ecto.MarkdownTest do
  use ExUnit.Case, async: true

  alias StaffNotes.Ecto.Markdown

  describe "to_html/1" do
    test "renders HTML unchanged" do
      assert Markdown.to_html(%Markdown{html: "<p>foo</p>"}) == "<p>foo</p>"
    end

    test "renders Markdown that hasn't been rendered yet" do
      assert Markdown.to_html(%Markdown{text: "# Foo"}) =~ "<h1>Foo</h1>"
    end

    test "renders a string as Markdown" do
      assert Markdown.to_html("# Foo") =~ "<h1>Foo</h1>"
    end

    test "renders anything else as the empty string" do
      assert Markdown.to_html(7) == ""
    end
  end

  describe "Phoenix.HTML.Safe" do
    test "implements the protocol" do
      assert Phoenix.HTML.Safe.to_iodata(%Markdown{text: "# Foo"}) =~ "<h1>Foo</h1>"
    end
  end
end
