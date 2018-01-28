defmodule StaffNotesWeb.Primer.Element do
  @moduledoc """
  A module to make it easy to define structures that will render themselves within Phoenix
  templates.
  """
  defmacro __using__(options) do
    class = options[:class]
    tag_name = options[:tag_name] || :div

    quote do
      @class unquote(class) || __MODULE__ |> Module.split() |> List.last()

      use Phoenix.HTML

      @type t :: %__MODULE__{content: Phoenix.HTML.safe(), options: Keyword.t()}
      defstruct(content: [], options: [])

      def render(%__MODULE__{} = element) do
        options = Keyword.update(element.options, :class, @class, &(@class <> " " <> &1))

        content_tag unquote(tag_name), element.content, options
      end

      defoverridable [render: 1]
    end
  end
end
