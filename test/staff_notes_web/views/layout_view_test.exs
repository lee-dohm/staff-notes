defmodule StaffNotesWeb.LayoutViewTest do
  use ExUnit.Case
  use Phoenix.HTML

  alias StaffNotesWeb.LayoutView

  def code_with_heart(author_info, options \\ []) do
    author_info
    |> LayoutView.code_with_heart(options)
    |> safe_to_string()
  end

  def github_link(options \\ []) do
    "https://github.com/owner/repo"
    |> LayoutView.github_link(options)
    |> safe_to_string()
  end

  def render_flash(flash) do
    flash
    |> LayoutView.render_flash()
    |> safe_to_string()
  end

  describe "code_with_heart/2" do
    test "renders the text as expected" do
      content = code_with_heart({"Author Name", "http://example.com"})

      assert content =~ ~r(^<div>.*</div>$)
      assert content =~ ~s( with )
      assert content =~ ~s( by <a href="http://example.com">Author Name</a>)
    end

    test "renders the link with supplied link options" do
      content = code_with_heart({"Author Name", "http://example.com"}, link_options: [foo: "bar"])

      assert content =~ ~s( by <a foo="bar" href="http://example.com">Author Name</a>)
    end

    test "renders the div with supplied options" do
      content = code_with_heart({"Author Name", "http://example.com"}, foo: "bar")

      assert content =~ ~r(^<div foo="bar">.*</div>$)
    end
  end

  describe "github_link/2" do
    test "renders the link" do
      assert github_link() =~ ~r(^<a href="https://github.com/owner/repo"><svg.*></a>$)
    end

    test "renders options as attributes on the link" do
      assert github_link(foo: "bar") =~
               ~r(^<a foo="bar" href="https://github.com/owner/repo">.*</a>$)
    end

    test "uses GitHub as the link text when :text option is true" do
      assert github_link(text: true) == ~s(<a href="https://github.com/owner/repo">GitHub</a>)
    end
  end

  describe "render_flash/1" do
    test "returns an empty string when given no flash info" do
      assert render_flash(%{}) == ""
    end

    test "returns an empty string when given nil" do
      assert render_flash(nil) == ""
    end

    test "returns the info flash when given only info flash information" do
      assert render_flash(%{info: "foo"}) == "<p class=\"flash\" role=\"alert\">foo</p>"
    end

    test "returns the error flash when given only error flash information" do
      assert render_flash(%{error: "foo"}) ==
               "<p class=\"flash flash-error\" role=\"alert\">foo</p>"
    end

    test "returns both error and info flash when given both" do
      content = render_flash(%{info: "foo", error: "bar"})

      assert content ==
               "<p class=\"flash\" role=\"alert\">foo</p><p class=\"flash flash-error\" role=\"alert\">bar</p>"
    end
  end
end
