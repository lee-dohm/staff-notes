defmodule StaffNotesWeb.TabNavHelpers do
  @moduledoc """
  Functions to construct
  [Primer tabnav elements](https://github.com/primer/primer/tree/master/modules/primer-navigation#tabnav).
  """
  use StaffNotesWeb, :helper

  @doc """
  Renders the tabnav element.

  ## Examples

  ```
  render_tabnav([tabnav_item("Text", "https://example.com")])
  ```
  """
  def render_tabnav(do: block) do
    content_tag(:div, class: "tabnav") do
      content_tag(:nav, block, class: "tabnav-tabs", "aria-label": "Navigation bar")
    end
  end

  @doc """
  Generates a tabnav item to be rendered inside a tabnav element.

  ## Examples

  ```
  tabnav_item("Settings", "https://example.com", counter: 5, icon: :gear, selected: true)
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
    if selected, do: options = Keyword.put(options, :"aria-current", "page")

    content_tag(:a, contents, options)
  end

  defp build_class(nil, nil), do: "tabnav-tab"
  defp build_class(nil, _), do: "tabnav-tab float-right"
  defp build_class(_, nil), do: "tabnav-tab selected"
  defp build_class(_, _), do: "tabnav-tab float-right selected"

  defp build_contents(nil, text, nil), do: [text]
  defp build_contents(icon, text, nil), do: [octicon(icon), text]
  defp build_contents(nil, text, counter), do: [text, content_tag(:span, counter, class: "Counter")]
  defp build_contents(icon, text, counter) do
    [
      octicon(icon),
      text,
      content_tag(:span, counter, class: "Counter")
    ]
  end
end
