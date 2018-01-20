defmodule StaffNotes.Ecto.MarkdownTest do
  use ExUnit.Case, async: true

  alias StaffNotes.Ecto.Markdown

  doctest Markdown

  describe "Phoenix.HTML.Safe" do
    test "implements the protocol" do
      assert Phoenix.HTML.Safe.to_iodata(%Markdown{text: "# Foo"}) =~ "<h1>Foo</h1>"
    end
  end
end
