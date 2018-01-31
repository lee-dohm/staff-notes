defmodule StaffNotes.MarkdownTest do
  use ExUnit.Case, async: true
  doctest StaffNotes.Markdown

  import Phoenix.HTML.Safe, only: [to_iodata: 1]

  alias StaffNotes.Markdown

  describe "Phoenix.HTML.Safe" do
    test "implements the protocol" do
      assert to_iodata(%Markdown{text: "# Foo"}) =~ "<h1>Foo</h1>"
    end
  end
end
