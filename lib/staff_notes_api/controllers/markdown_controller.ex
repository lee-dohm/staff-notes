defmodule StaffNotesApi.MarkdownController do
  @moduledoc """
  Handler for the `/api/markdown` path.
  """
  use StaffNotesApi, :controller

  alias StaffNotes.Ecto.Markdown

  @doc """
  Renders the Markdown received and returns an HTML fragment.
  """
  def render(conn, %{"markdown" => markdown}) do
    text(conn, Markdown.to_html(markdown))
  end
end
