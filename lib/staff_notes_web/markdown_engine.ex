defmodule StaffNotesWeb.MarkdownEngine do
  @moduledoc """
  Allows the use of `markdown:` blocks in Slime templates.
  """
  @behaviour Slime.Parser.EmbeddedEngine

  alias StaffNotes.Markdown

  def render(text, _options), do: Markdown.to_html(text)
end
