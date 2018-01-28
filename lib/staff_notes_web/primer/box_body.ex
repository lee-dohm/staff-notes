defmodule StaffNotesWeb.Primer.BoxBody do
  @moduledoc """
  Represents a GitHub Primer Box body element.
  """
  use StaffNotesWeb.Primer.Element, class: "Box-body"

  defimpl Phoenix.HTML.Safe do
    def to_iodata(%StaffNotesWeb.Primer.BoxBody{} = box_body) do
      StaffNotesWeb.Primer.BoxBody.render(box_body)
    end
  end
end
