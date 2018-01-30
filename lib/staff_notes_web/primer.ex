defmodule StaffNotesWeb.Primer do
  @moduledoc """
  Helper functions used to render GitHub Primer elements in templates.

  To make code reuse simple, each element type is represented by an Elixir struct, such as
  `t:StaffNotesWeb.Primer.Box.t/0`. Each struct is coupled with code that knows how to render that
  struct into a `Phoenix.HTML.safe()` value so that they can be easily used in templates or composed
  into larger functions in code.

  ## Examples

  Use in a Slime template:

  ```
  = Primer.box do
    = Primer.box_body do
      | Test
  ```

  This will generate:

  ```html
  <div class="Box">
    <div class="Box-body">
      Test
    </div>
  </div>
  ```

  See `StaffNotesWeb.PrimerHelpers.render_list/4` for an example of how to use these functions to
  compose larger structures.
  """
  use Phoenix.HTML

  import Phoenix.HTML.Safe, only: [to_iodata: 1]

  elements = [
    StaffNotesWeb.Primer.Box,
    StaffNotesWeb.Primer.BoxBody,
    StaffNotesWeb.Primer.BoxRow
  ]

  Enum.each(elements, fn element ->
    fn_name =
      element
      |> Module.split()
      |> List.last()
      |> Macro.underscore()
      |> String.to_atom()

    module_text =
      element
      |> Module.split()
      |> Enum.join(".")

    @doc """
    Renders a `#{module_text}` element.
    """
    def unquote(fn_name)(content)

    def unquote(fn_name)(do: block) do
      unquote(fn_name)(block, [])
    end

    def unquote(fn_name)(content) do
      unquote(fn_name)(content, [])
    end

    @doc """
    Renders a `#{module_text}` element.
    """
    def unquote(fn_name)(content, options)

    def unquote(fn_name)(options, do: block) when is_list(options) do
      unquote(fn_name)(block, options)
    end

    def unquote(fn_name)(content, options) when is_list(options) do
      to_iodata(%unquote(element){content: content, options: options})
    end
  end)
end
