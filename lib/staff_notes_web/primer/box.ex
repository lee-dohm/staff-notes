defmodule StaffNotesWeb.Primer.Box do
  @moduledoc """
  Represents a GitHub Primer [Box element](https://github.com/primer/primer/tree/master/modules/primer-box).

  Implements the `Phoenix.HTML.Safe` protocol so that it can be rendered directly by being emitted
  into a template.
  """
  use Phoenix.HTML

  @type t :: %__MODULE__{content: Keyword.t(), options: Keyword.t()}
  defstruct(content: [], options: [])

  @doc """
  Renders the `StaffNotesWeb.Primer.Box` element.
  """
  @spec render(t()) :: Phoenix.HTML.safe()
  def render(%__MODULE__{} = box) do
    options = Keyword.update(box.options, :class, "Box", &("Box #{&1}"))

    content_tag :div, box.content, options
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(%StaffNotesWeb.Primer.Box{} = box) do
      StaffNotesWeb.Primer.Box.render(box)
    end
  end
end
