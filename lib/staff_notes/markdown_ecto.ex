defmodule StaffNotes.Markdown.Ecto do
  @moduledoc """
  A custom Ecto type for storing and retrieving blocks of Markdown in the database.

  Use this as the type of the database field in the schema:

  ```
  defmodule StaffNotes.Notes.Note do
    use Ecto.Schema
    alias StaffNotes.Markdown

    schema "notes" do
      field :title, :string
      field :text, Markdown.Ecto
    end
  end
  ```

  See: [Beyond Functions in Elixir: Refactoring for Maintainability][beyond-functions]

  [beyond-functions]: https://blog.usejournal.com/beyond-functions-in-elixir-refactoring-for-maintainability-5c73daba77f3
  """
  alias StaffNotes.Markdown

  @behaviour Ecto.Type

  @impl Ecto.Type
  def type, do: :string

  @impl Ecto.Type
  def cast(binary) when is_binary(binary) do
    {:ok, %Markdown{text: binary}}
  end

  def cast(%Markdown{} = markdown), do: {:ok, markdown}
  def cast(_other), do: :error

  @impl Ecto.Type
  def load(binary) when is_binary(binary) do
    {:ok, %Markdown{text: binary, html: Markdown.to_html(binary)}}
  end

  def load(_other), do: :error

  @impl Ecto.Type
  def dump(%Markdown{text: binary}) when is_binary(binary) do
    {:ok, binary}
  end

  def dump(binary) when is_binary(binary), do: {:ok, binary}
  def dump(_other), do: :error
end
