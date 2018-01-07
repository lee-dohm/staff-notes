defmodule StaffNotes.Ecto.Slug do
  @moduledoc """
  An `Ecto.Type` that represents an identifier that can be used in a URL.

  This type also makes it so that `binary_id` is distinguishable from a name because it keeps them
  both strongly typed.

  ## Use

  Use this as the type of the database field in the schema:

  ```
  defmodule StaffNotes.Accounts.Organization do
    use Ecto.Schema
    alias StaffNotes.Ecto.Slug

    schema "organizations" do
      field :name, Slug
    end
  end
  ```

  ## Format

  Follows the GitHub pattern for logins. They consist of:

  * Alphanumerics &mdash; `/[a-zA-Z0-9]/`
  * Hyphens &mdash; `/-/`
  * Must begin and end with an alphanumeric
  """
  @pattern ~r{\A[a-z0-9]+(-[a-z0-9]+)*\z}i

  @behaviour Ecto.Type

  @type t :: %__MODULE__{text: String.t}

  defstruct text: ""

  @doc """
  Returns the underlying schema type for a slug.
  """
  @impl Ecto.Type
  def type, do: :string

  @doc """
  Casts the given value into a slug.
  """
  @impl Ecto.Type
  def cast(%__MODULE__{} = slug) do
    if __MODULE__.valid?(slug) do
      {:ok, slug}
    else
      :error
    end
  end

  def cast(binary) when is_binary(binary), do: cast(%__MODULE__{text: binary})

  def cast(_other), do: :error

  @doc """
  Loads the given value into a slug.
  """
  @impl Ecto.Type
  def load(binary) when is_binary(binary) do
    if __MODULE__.valid?(binary) do
      {:ok, %__MODULE__{text: binary}}
    else
      :error
    end
  end

  def load(_other), do: :error

  @doc """
  Dumps the given value into an `Ecto` native type.
  """
  @impl Ecto.Type
  def dump(%__MODULE__{} = slug), do: dump(slug.text)

  def dump(binary) when is_binary(binary) do
    if __MODULE__.valid?(binary) do
      {:ok, binary}
    else
      :error
    end
  end

  def dump(_other), do: :error

  @doc """
  Converts a slug to iodata.
  """
  def to_iodata(%__MODULE__{} = slug), do: __MODULE__.to_string(slug)

  @doc """
  Converts a slug to a string.
  """
  def to_string(%__MODULE__{} = slug) do
    if StaffNotes.Ecto.Slug.valid?(slug), do: slug.text, else: "INVALID SLUG #{slug.text}"
  end

  @doc """
  Determines whether the given value is valid to be used as a slug.
  """
  @spec valid?(t | String.t) :: boolean
  def valid?(binary) when is_binary(binary), do: binary =~ @pattern
  def valid?(%__MODULE__{text: binary}) when is_binary(binary), do: binary =~ @pattern
  def valid?(_), do: false

  defimpl Phoenix.HTML.Safe do
    def to_iodata(%StaffNotes.Ecto.Slug{} = slug), do: StaffNotes.Ecto.Slug.to_iodata(slug)
  end

  defimpl String.Chars do
    def to_string(%StaffNotes.Ecto.Slug{} = slug), do: StaffNotes.Ecto.Slug.to_string(slug)
  end
end
