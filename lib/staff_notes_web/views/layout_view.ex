defmodule StaffNotesWeb.LayoutView do
  @moduledoc """
  View functions for the site's page layout.
  """
  use StaffNotesWeb, :view

  @doc """
  Renders the GitHub-style "<> with ♥ by [author link]" footer item.
  """
  @spec code_with_heart(String.t, String.t, Keyword.t) :: Phoenix.HTML.safe
  def code_with_heart(name, location, options \\ []) do
    {link_options, options} = Keyword.pop(options, :link_options)
    link_options = Keyword.merge([to: location], link_options)

    content_tag(:div, options) do
      [
        octicon(:code),
        gettext(" with "),
        octicon(:heart),
        gettext(" by "),
        link(name, link_options)
      ]
    end
  end

  @doc """
  Renders the link to the source repository using the GitHub mark octicon.

  All options are passed to `Phoenix.HTML.Link.link/2`.
  """
  @spec github_link(String.t, Keyword.t) :: Phoenix.HTML.safe
  def github_link(repo_url, options) do
    options = Keyword.merge([to: repo_url], options)

    link(octicon("mark-github"), options)
  end

  @doc """
  Renders the flash content.

  ## Examples

  ```
  render_flash(get_flash(@conn))
  ```
  """
  @spec render_flash(Map.t) :: Phoenix.HTML.safe
  def render_flash(flash), do: render_flash([], flash)

  defp render_flash(content, flash = %{error: message}) do
    {:safe, error_flash} = content_tag(:p, message, role: "alert", class: "flash flash-error")

    render_flash([error_flash | content], Map.drop(flash, [:error]))
  end

  defp render_flash(content, flash = %{info: message}) do
    {:safe, info_flash} = content_tag(:p, message, role: "alert", class: "flash")

    render_flash([info_flash | content], Map.drop(flash, [:info]))
  end

  defp render_flash(content, _), do: {:safe, content}
end
