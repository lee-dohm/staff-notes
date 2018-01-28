defmodule StaffNotesWeb.Primer.Box do
  @moduledoc """
  Represents a GitHub Primer [Box element](https://github.com/primer/primer/tree/master/modules/primer-box).
  """
  use StaffNotesWeb.Primer.Element

  defimpl Phoenix.HTML.Safe do
    def to_iodata(%StaffNotesWeb.Primer.Box{} = box) do
      StaffNotesWeb.Primer.Box.render(box)
    end
  end
end
