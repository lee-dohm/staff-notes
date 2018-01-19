defmodule StaffNotesWeb.PrimerHelpers do
  @moduledoc """
  Helper functions for generating elements that work with [Primer](https://primer.github.io/).
  """
  use Phoenix.HTML

  alias Phoenix.HTML.Form
  alias StaffNotesWeb.ErrorHelpers

  @doc """
  Generates a link button with the given text and options.

  ## Options

  * **required** `:to` -- the URL to link to
  """
  def link_button(text, options \\ []) do
    options = Keyword.merge(options, type: "button")

    link(text, options)
  end

  @doc """
  Displays the appropriate input control for the given field.

  See:
  [Dynamic forms with Phoenix](http://blog.plataformatec.com.br/2016/09/dynamic-forms-with-phoenix/)
  """
  def input(form, field, options \\ []) do
    type = options[:using] || Form.input_type(form, field)

    wrapper_opts = [class: "form-group #{error_class(form, field)}"]
    label_opts = []
    input_opts = [class: "form-control #{options[:class]}"]

    content_tag :dl, wrapper_opts do
      label =
        content_tag :dt do
          label(form, field, humanize(field), label_opts)
        end

      input =
        content_tag :dd do
          input(type, form, field, input_opts)
        end

      error = error_tag(form, field) || ""

      [label, input, error]
    end
  end

  defp input(:markdown, form, field, input_opts) do
    content =
      form
      |> Form.input_value(field)
      |> Map.get(:text)

    opts = Keyword.merge(input_opts, id: Form.input_id(form, field), name: Form.input_name(form, field))

    content_tag(:textarea, content <> "\n", opts)
  end

  defp input(type, form, field, input_opts) do
    apply(Form, type, [form, field, input_opts])
  end

  defp error_class(form, field) do
    cond do
      !form.source.action -> ""
      form.errors[field] -> "errored"
      true -> ""
    end
  end

  defp error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag :dd, class: "error" do
        ErrorHelpers.translate_error(error)
      end
    end)
  end
end
