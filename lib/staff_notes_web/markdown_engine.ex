defmodule StaffNotesWeb.MarkdownEngine do
  @moduledoc """
  Allows the use of `markdown:` blocks in Slime templates.
  """
  @behaviour Slime.Parser.EmbeddedEngine

  require Logger

  def render(text, _options) do
    Cmark.to_html(text, [:safe, :smart])
  end
end
