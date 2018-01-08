defmodule StaffNotesWeb.PrimerFormHelpers do
  @moduledoc """
  Helper functions for generating forms that work with
  [Primer](https://github.com/primer/primer/tree/master/modules/primer-forms).
  """
  use Phoenix.HTML

  alias Phoenix.HTML.Form
  alias StaffNotesWeb.ErrorHelpers

  @doc """
  Displays the appropriate input control for the given field.

  See: http://blog.plataformatec.com.br/2016/09/dynamic-forms-with-phoenix/
  """
  def input(form, field) do
    type = Form.input_type(form, field)

    wrapper_opts = [class: "form-group #{error_class(form, field)}"]
    label_opts = []
    input_opts = [class: "form-control"]

    content_tag(:dl, wrapper_opts) do
      label = content_tag(:dt) do
        label(form, field, humanize(field), label_opts)
      end

      input = content_tag(:dd) do
        apply(Form, type, [form, field, input_opts])
      end

      error = error_tag(form, field) || ""

      [label, input, error]
    end
  end

  defp error_class(form, field) do
    cond do
      !form.source.action -> ""
      form.errors[field] -> "errored"
      true -> ""
    end
  end

  defp error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn (error) ->
      content_tag(:dd, class: "error") do
        ErrorHelpers.translate_error(error)
      end
    end)
  end
end
