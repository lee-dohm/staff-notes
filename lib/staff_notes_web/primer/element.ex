defmodule StaffNotesWeb.Primer.Element do
  @moduledoc """
  A module to make it easy to define new structure types that will render themselves within Phoenix
  templates.

  ## Options

  * `:class` &mdash; CSS class to use on the content tag that this structure represents
    _(**default:** the last component of the module name)_
  * `:tag` &mdash; HTML tag to use when rendering the element _(**default:** `:div`)_

  ## Examples

  ```
  # defmodule StaffNotesWeb.Primer.Foo do
  #   use StaffNotesWeb.Primer.Element
  # end
  #
  iex> Phoenix.HTML.safe_to_string(%StaffNotesWeb.Primer.Foo{})
  "<div class=\"Foo\"></div>"
  iex> Phoenix.HTML.safe_to_string(%StaffNotesWeb.Primer.Foo{options: [class: "test"]})
  "<div class=\"Foo test\"></div>"
  iex> Phoenix.HTML.safe_to_string(%StaffNotesWeb.Primer.Foo{ontent: "Content", options: [class: "test"]})
  "<div class=\"Foo test\">Content</div>"
  ```
  """
  defmacro __using__(options) do
    class = options[:class]
    tag_name = options[:tag_name] || :div

    quote do
      @class unquote(class) || __MODULE__ |> Module.split() |> List.last()

      use Phoenix.HTML

      @type t :: %__MODULE__{content: Phoenix.HTML.unsafe(), options: Keyword.t()}
      defstruct(content: [], options: [])

      def render(%__MODULE__{} = element) do
        options = Keyword.update(element.options, :class, @class, &(@class <> " " <> &1))

        content_tag(unquote(tag_name), element.content, options)
      end

      defoverridable render: 1
    end
  end
end
