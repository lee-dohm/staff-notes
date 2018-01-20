defmodule StaffNotes.Ecto.Markdown do
  @moduledoc """
  An `Ecto.Type` that represents a chunk of [Markdown](http://commonmark.org) to be rendered.

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
  @type t :: %__MODULE__{text: String.t(), html: nil | String.t()}
  defstruct text: "", html: nil

  @type markdown :: %__MODULE__{} | String.t()

  @behaviour Ecto.Type

  @impl Ecto.Type
  def type, do: :string

  @impl Ecto.Type
  def cast(binary) when is_binary(binary) do
    {:ok, %__MODULE__{text: binary}}
  end

  def cast(%__MODULE__{} = markdown), do: {:ok, markdown}
  def cast(_other), do: :error

  @impl Ecto.Type
  def load(binary) when is_binary(binary) do
    {:ok, %__MODULE__{text: binary, html: to_html(binary)}}
  end

  def load(_other), do: :error

  @impl Ecto.Type
  def dump(%__MODULE__{text: binary}) when is_binary(binary) do
    {:ok, binary}
  end

  def dump(binary) when is_binary(binary), do: {:ok, binary}
  def dump(_other), do: :error

  @doc """
  Renders the supplied Markdown as HTML.

  ## Examples

  Render Markdown from a string:

  ```
  iex> StaffNotes.Ecto.Markdown.to_html("# Foo")
  "<h1>Foo</h1>\n"
  ```

  Render Markdown from a `Markdown` struct:

  ```
  iex> StaffNotes.Ecto.Markdown.to_html(%StaffNotes.Ecto.Markdown{text: "# Foo"})
  "<h1>Foo</h1>\n"
  ```

  Passes already rendered Markdown through unchanged:

  ```
  iex> StaffNotes.Ecto.Markdown.to_html(%StaffNotes.Ecto.Markdown{html: "<p>foo</p>"})
  "<p>foo</p>"
  ```

  Returns an empty string for anything that isn't a string or a `Markdown` struct:

  ```
  iex> StaffNotes.Ecto.Markdown.to_html(5)
  ""
  ```
  """
  @spec to_html(markdown) :: String.t()
  def to_html(markdown)

  def to_html(%__MODULE__{html: html}) when is_binary(html), do: html
  def to_html(%__MODULE__{text: text}), do: to_html(text)

  def to_html(text) when is_binary(text) do
    Cmark.to_html(text, [:safe, :smart])
  end

  def to_html(_other), do: ""

  @doc """
  Converts a block of markdown to iodata.
  """
  def to_iodata(%__MODULE__{} = markdown), do: to_html(markdown)

  defimpl Phoenix.HTML.Safe do
    def to_iodata(%StaffNotes.Ecto.Markdown{} = markdown) do
      StaffNotes.Ecto.Markdown.to_iodata(markdown)
    end
  end
end
