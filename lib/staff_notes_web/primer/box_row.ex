defmodule StaffNotesWeb.Primer.BoxRow do
  use Phoenix.HTML

  defstruct(content: [], options: [])

  def render(%__MODULE__{} = box_row) do
    options = Keyword.update(box_row.options, :class, "Box-row", &("Box-row #{&1}"))

    content_tag :li, box_row.content, options
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(%StaffNotesWeb.Primer.BoxRow{} = box_row) do
      StaffNotesWeb.Primer.BoxRow.render(box_row)
    end
  end
end
