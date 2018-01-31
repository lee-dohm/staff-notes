defmodule StaffNotes.Ecto.Markdown do
  @moduledoc """
  An `Ecto.Type` that handles the conversion between a string in the database and a
  `StaffNotes.Markdown` struct in memory.

  Use this as the type of the database field in the schema:

  ```
  defmodule StaffNotes.Notes.Note do
    use Ecto.Schema
    alias StaffNotes.Ecto.Markdown

    schema "notes" do
      field :title, :string
      field :text, Markdown
    end
  end
  ```

  This type requires special handling in forms because Phoenix's form builder functions call
  `Phoenix.HTML.html_escape/1` on all field values, which returns the `html` field on this type. But
  what we want when we show an `t:StaffNotes.Ecto.Markdown.t/0` value in a form is the `text` field.

  See: [Beyond Functions in Elixir: Refactoring for Maintainability][beyond-functions]

  [beyond-functions]: https://blog.usejournal.com/beyond-functions-in-elixir-refactoring-for-maintainability-5c73daba77f3
  """
  @behaviour Ecto.Type

  @doc """
  Returns the underlying schema type for the custom type.

  See: `c:Ecto.Type.type/0`
  """
  @impl Ecto.Type
  def type, do: :string

  @doc """
  Casts the given input to the custom type.

  See: `c:Ecto.Type.cast/1`
  """
  @impl Ecto.Type
  def cast(binary) when is_binary(binary) do
    {:ok, %StaffNotes.Markdown{text: binary}}
  end

  def cast(%StaffNotes.Markdown{} = markdown), do: {:ok, markdown}
  def cast(_other), do: :error

  @doc """
  Loads the given term into a custom type.

  See: `c:Ecto.Type.load/1`
  """
  @impl Ecto.Type
  def load(binary) when is_binary(binary) do
    {:ok, %StaffNotes.Markdown{text: binary, html: StaffNotes.Markdown.to_html(binary)}}
  end

  def load(_other), do: :error

  @doc """
  Dumps the given term into an Ecto native type.

  See: `c:Ecto.Type.dump/1`
  """
  @impl Ecto.Type
  def dump(%StaffNotes.Markdown{text: binary}) when is_binary(binary) do
    {:ok, binary}
  end

  def dump(binary) when is_binary(binary), do: {:ok, binary}
  def dump(_other), do: :error
end
