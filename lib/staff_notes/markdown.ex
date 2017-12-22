defmodule StaffNotes.Markdown do
  @moduledoc """
  Represents a chunk of Markdown to be rendered.

  See: [Beyond Functions in Elixir: Refactoring for Maintainability][beyond-functions]

  [beyond-functions]: https://blog.usejournal.com/beyond-functions-in-elixir-refactoring-for-maintainability-5c73daba77f3
  """
  @type t :: %__MODULE__{text: String.t, html: nil | String.t}
  defstruct text: "", html: nil

  @type markdown :: %__MODULE__{} | String.t

  @doc """
  Renders the supplied Markdown as HTML.

  ## Examples

  Render Markdown from a string:

  ```
  iex> StaffNotes.Markdown.to_html("# Foo")
  "<h1>Foo</h1>\n"
  ```

  Render Markdown from a `StaffNotes.Markdown` struct:

  ```
  iex> StaffNotes.Markdown.to_html(%StaffNotes.Markdown{text: "# Foo"})
  "<h1>Foo</h1>\n"
  ```

  Passes HTML through unchanged:

  ```
  iex> StaffNotes.Markdown.to_html(%StaffNotes.Markdown{html: "<p>foo</p>"})
  "<p>foo</p>"
  ```
  """
  @spec to_html(markdown) :: String.t
  def to_html(markdown)

  def to_html(%__MODULE__{html: html}) when is_binary(html), do: html
  def to_html(%__MODULE__{text: text}), do: to_html(text)

  def to_html(text) when is_binary(text) do
    Cmark.to_html(text, [:safe, :smart])
  end

  def to_html(_other), do: ""

  defimpl Phoenix.HTML.Safe do
    def to_iodata(%StaffNotes.Markdown{} = markdown) do
      StaffNotes.Markdown.to_html(markdown)
    end
  end
end
