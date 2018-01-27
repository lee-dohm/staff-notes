defmodule StaffNotesWeb.Primer.BoxBody do
  use Phoenix.HTML

  defstruct(content: [], options: [])

  def render(%__MODULE__{} = box_body) do
    options = Keyword.update(box_body.options, :class, "Box-body", &("Box-body #{&1}"))

    content_tag :div, box_body.content, options
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(%StaffNotesWeb.Primer.BoxBody{} = box_body) do
      StaffNotesWeb.Primer.BoxBody.render(box_body)
    end
  end
end
