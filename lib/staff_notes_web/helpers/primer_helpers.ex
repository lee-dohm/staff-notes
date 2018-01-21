defmodule StaffNotesWeb.PrimerHelpers do
  @moduledoc """
  Helper functions for generating elements that work with [Primer](https://primer.github.io/).
  """
  use Phoenix.HTML

  import Phoenix.View, only: [render: 3, render_many: 4]
  import PhoenixOcticons

  alias Phoenix.HTML.Form
  alias StaffNotes.Ecto.Markdown
  alias StaffNotesWeb.ErrorHelpers

  @doc """
  Displays the avatar for the `StaffNotes.Accounts.User`.

  ## Options

  Valid options are:

  * `:size` -- the value in pixels to use for both the width and height of the avatar image
  """
  @spec avatar(User.t(), keyword) :: Phoenix.HTML.safe()
  def avatar(user, options \\ [])

  def avatar(user, []) do
    content_tag(:img, "", class: "avatar", src: user.avatar_url)
  end

  def avatar(user, size: size) do
    content_tag(
      :img,
      "",
      class: "avatar",
      src: "#{user.avatar_url}&s=#{size}",
      width: size,
      height: size
    )
  end

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

  ## Options

  * `:using` -- override the built-in selection of input field based on data type. Can be any of the
    `Phoenix.HTML.Form` input function names or the special value `:markdown` which displays a
    specially-formatted `textarea`

  See:
  [Dynamic forms with Phoenix](http://blog.plataformatec.com.br/2016/09/dynamic-forms-with-phoenix/)
  """
  @spec input(Phoenix.HTML.FormData.t(), atom, keyword) :: Phoenix.HTML.safe()
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

  @doc """
  Renders a standard list of items.

  Takes the same parameters and options as `Phoenix.View.render_many/4` except that the
  `template_root` parameter is the root name of the template. This root name will have either
  `_blankslate.html` appended if `collection` is empty or have `_item.html` appended if the
  collection is non-empty.
  """
  def render_list(collection, module, template_root, assigns \\ %{}) do
    content_tag :div, class: "Box" do
      content_tag :div, class: "Box-body" do
        content_tag :ul do
          render_items(collection, module, template_root, assigns)
        end
      end
    end
  end

  @doc """
  Renders the tabnav element.

  ## Examples

  In Elixir code:

  ```
  tabnav do
    [
      tabnav_item("Text", "https://example.com")
    ]
  end
  ```

  In Slime template:

  ```
  = tabnav do
    = tabnav_item("Text", "https://example.com")
  ```
  """
  def tabnav(do: block) do
    content_tag :div, class: "tabnav" do
      content_tag(:nav, block, class: "tabnav-tabs", "aria-label": "Navigation bar")
    end
  end

  @doc """
  Generates a tabnav item to be rendered inside a tabnav element.

  ## Examples

  Rendering a tabnav item with an icon, counter, aligned right, and selected:

  ```
  tabnav_item(
    "Settings",
    "https://example.com",
    counter: 5,
    icon: :gear,
    right: true,
    selected: true
  )
  ```
  """
  def tabnav_item(text, path, options \\ []) do
    selected = Keyword.get(options, :selected)
    icon = Keyword.get(options, :icon)
    right = Keyword.get(options, :right)
    counter = Keyword.get(options, :counter)

    contents = build_contents(icon, text, counter)
    class = build_class(selected, right)

    options = [href: path, class: class]
    options = if selected, do: Keyword.put(options, :"aria-current", "page"), else: options

    content_tag(:a, contents, options)
  end

  defp build_class(false, right), do: build_class(nil, right)
  defp build_class(nil, nil), do: "tabnav-tab"
  defp build_class(nil, _), do: "tabnav-tab float-right"
  defp build_class(_, nil), do: "tabnav-tab selected"
  defp build_class(_, _), do: "tabnav-tab float-right selected"

  defp build_contents(nil, text, nil), do: [text]
  defp build_contents(icon, text, nil), do: [octicon(icon), text]

  defp build_contents(nil, text, counter) do
    [text, content_tag(:span, counter, class: "Counter")]
  end

  defp build_contents(icon, text, counter) do
    [
      octicon(icon),
      text,
      content_tag(:span, counter, class: "Counter")
    ]
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

  defp input(:markdown, form, field, input_opts) do
    content =
      case Form.input_value(form, field) do
        nil -> nil
        %Markdown{} = markdown -> markdown.text
      end

    opts =
      Keyword.merge(
        input_opts,
        id: Form.input_id(form, field),
        name: Form.input_name(form, field)
      )

    content_tag(:textarea, "#{content}\n", opts)
  end

  defp input(type, form, field, input_opts) do
    apply(Form, type, [form, field, input_opts])
  end

  defp render_items(collection, module, template, assigns) when length(collection) == 0 do
    render(module, "#{template}_blankslate.html", assigns)
  end

  defp render_items(collection, module, template, assigns) do
    render_many(collection, module, "#{template}_item.html", assigns)
  end
end
