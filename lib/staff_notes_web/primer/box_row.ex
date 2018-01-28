defmodule StaffNotesWeb.Primer.BoxRow do
  use StaffNotesWeb.Primer.Element, class: "Box-row", tag_name: :li

  defimpl Phoenix.HTML.Safe do
    def to_iodata(%StaffNotesWeb.Primer.BoxRow{} = box_row) do
      StaffNotesWeb.Primer.BoxRow.render(box_row)
    end
  end
end
