defmodule StaffNotesApi.MarkdownController do
  @moduledoc """
  Handler for the `/api/markdown` path.
  """
  use StaffNotesApi, :controller

  alias StaffNotes.Ecto.Markdown

  plug StaffNotesApi.TokenAuthentication

  @doc """
  Renders the Markdown received and returns an HTML fragment.

  ## Examples

  Accepts a JSON body:

  ```json
  {
    "markdown": "# Foo"
  }
  ```

  Returns the equivalent HTML fragment:

  ```html
  <h1>Foo</h1>
  ```
  """
  def render(conn, %{"markdown" => markdown}) do
    text(conn, Markdown.to_html(markdown))
  end
end
