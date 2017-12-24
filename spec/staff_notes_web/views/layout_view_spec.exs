defmodule StaffNotesWeb.LayoutViewSpec do
  use ESpec.Phoenix, async: true, view: LayoutView
  use Phoenix.HTML

  alias StaffNotesWeb.LayoutView


  describe "code_with_heart/2" do
    let :content do
      info()
      |> LayoutView.code_with_heart(options())
      |> safe_to_string
    end

    let :info, do: {"Author Name", "http://example.com"}
    let :options, do: []

    it "renders the text as expected" do
      expect(content()).to match(~r(^<div>.*</div>$))
      expect(content()).to have(~s( with ))
      expect(content()).to have(~s( by <a href="http://example.com">Author Name</a>))
    end

    context "when link options are supplied" do
      let :options, do: [link_options: [foo: "bar"]]

      it "renders the link options as attributes on the author link" do
        expect(content()).to have(~s( by <a foo="bar" href="http://example.com">Author Name</a>))
      end
    end

    context "when options are supplied" do
      let :options, do: [foo: "bar"]

      it "renders the options as attributes on the div" do
        expect(content()).to match(~r(^<div foo="bar">.*</div>$))
      end
    end
  end

  describe "github_link/2" do
    let :content do
      url()
      |> LayoutView.github_link(options())
      |> safe_to_string
    end

    let :options, do: []
    let :url, do: "https://github.com/owner/repo"

    it "renders the link as expected" do
      expect(content()).to match(~r(^<a href="https://github.com/owner/repo"><svg.*></a>$))
    end

    context "when options are supplied" do
      let :options, do: [foo: "bar"]

      it "renders the options as attributes on the link" do
        expect(content()).to match(~r(^<a foo="bar" href="https://github.com/owner/repo">.*</a>$))
      end
    end

    context "when :text is true" do
      let :options, do: [text: true]

      it "uses GitHub as the link text" do
        expect(content()).to eq(~s(<a href="https://github.com/owner/repo">GitHub</a>))
      end
    end
  end

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
