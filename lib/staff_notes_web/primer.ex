defmodule StaffNotesWeb.Primer do
  @moduledoc """
  Helper functions used to render GitHub Primer elements in templates.
  """
  use Phoenix.HTML

  import Phoenix.HTML.Safe, only: [to_iodata: 1]

  alias StaffNotesWeb.Primer.Box
  alias StaffNotesWeb.Primer.BoxBody
  alias StaffNotesWeb.Primer.BoxRow

  @doc """
  Constructs a `StaffNotesWeb.Primer.Box` element.
  """
  def box([do: block]) do
    box(block, [])
  end

  def box(content) do
    box(content, [])
  end

  def box(options, [do: block]) when is_list(options) do
    box(block, options)
  end

  def box(content, options) when is_list(options) do
    to_iodata(%Box{content: content, options: options})
  end

  def box_body([do: block]) do
    box_body(block, [])
  end

  def box_body(content) do
    box_body(content, [])
  end

  def box_body(options, [do: block]) when is_list(options) do
    box_body(block, options)
  end

  def box_body(content, options) when is_list(options) do
    to_iodata(%BoxBody{content: content, options: options})
  end

  def box_row([do: block]) do
    box_row(block, [])
  end

  def box_row(content) do
    box_row(content, [])
  end

  def box_row(options, [do: block]) when is_list(options) do
    box_row(block, options)
  end

  def box_row(content, options) when is_list(options) do
    to_iodata(%BoxRow{content: content, options: options})
  end
end
