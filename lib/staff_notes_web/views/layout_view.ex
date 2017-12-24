defmodule StaffNotesWeb.LayoutView do
  @moduledoc """
  View functions for the site's page layout.
  """
  use StaffNotesWeb, :view

  @type maybe_user :: StaffNotes.Accounts.User.t | nil

  @doc """
  Renders the GitHub-style `<> with ♥ by [author link]` footer item.

  This function can read the author link information from the `Application` environment. You can set
  the author link information by adding the following to your `config.exs`:

  ```
  config :app_name,
    author_name: "Author's name",
    author_url: "https://example.com"
  ```

  Or you can supply the author link information as a `{name, url}` tuple as the first argument.

  ## Options

  Options are used to customize the rendering of the element.

  * `:link_options` -- passed as attributes to the author link `a` tag
  * All other options are applied as attributes to the containing `div` element

  ## Examples

  ```
  Phoenix.HTML.safe_to_string(LayoutView.code_with_heart(:app_name))
  #=> "<div><svg .../> with <svg .../> by <a href=\"https://example.com\">Author's Name</a></div>"
  ```
  """
  @spec code_with_heart(atom | {String.t, String.t}, Keyword.t) :: Phoenix.HTML.safe
  def code_with_heart(link_info, options \\ [])

  def code_with_heart(app_name, options) when is_atom(app_name) do
    name = Application.get_env(app_name, :author_name)
    location = Application.get_env(app_name, :author_url)

    code_with_heart({name, location}, options)
  end

  def code_with_heart({name, location} = tuple, options) when is_tuple(tuple) do
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
  Renders the appropriate login buttons depending on whether the user is signed in.

  When `current_user` is `nil`, the login button is displayed. When `current_user` is defined, a
  logout link and link to the user's profile page is displayed.
  """
  @spec login_button(Plug.Conn.t, maybe_user) :: Phoenix.HTML.safe
  def login_button(conn, current_user)

  def login_button(conn, nil) do
    link(to: auth_path(conn, :index, from: conn.request_path), class: "btn") do
      [
        gettext("Sign in with"),
        octicon("mark-github")
      ]
    end
  end

  def login_button(conn, current_user) do
    [
      link(to: auth_path(conn, :delete)) do
        [
          octicon("sign-out"),
          " ",
          gettext("Sign Out")
        ]
      end,
      link(to: user_path(conn, :show, current_user)) do
        [
          current_user.name,
          avatar(current_user, size: 36)
        ]
      end
    ]
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

  defp render_flash(content, %{error: message} = flash) do
    {:safe, error_flash} = content_tag(:p, message, role: "alert", class: "flash flash-error")

    render_flash([error_flash | content], Map.drop(flash, [:error]))
  end

  defp render_flash(content, %{info: message} = flash) do
    {:safe, info_flash} = content_tag(:p, message, role: "alert", class: "flash")

    render_flash([info_flash | content], Map.drop(flash, [:info]))
  end

  defp render_flash(content, _), do: {:safe, content}
end
