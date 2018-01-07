defmodule StaffNotes.Slug do
  @moduledoc """
  Represents an identifier that can be used in a URL.

  Follows the GitHub pattern for logins. They consist of:

  * Alphanumerics &mdash; `/[a-zA-Z0-9]/`
  * Hyphens &mdash; `/-/`
  * Must begin and end with an alphanumeric

  Which means it must satisfy this regular expression: `/\A[a-z0-9]+(-[a-z0-9]+)*\z/i`
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
  Determines whether the given value is valid to be used as a slug.
  """
  @spec valid?(t | String.t) :: boolean
  def valid?(binary) when is_binary(binary), do: binary =~ @pattern
  def valid?(%__MODULE__{text: binary}) when is_binary(binary), do: binary =~ @pattern
  def valid?(_), do: false

  defimpl Phoenix.HTML.Safe do
    def to_iodata(%StaffNotes.Slug{} = slug), do: to_string(slug)
  end

  defimpl String.Chars do
    def to_string(%StaffNotes.Slug{} = slug) do
      if StaffNotes.Slug.valid?(slug), do: slug.text, else: "INVALID SLUG #{slug.text}"
    end
  end
end
