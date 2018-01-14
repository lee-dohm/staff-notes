defmodule StaffNotesWeb.LayoutView do
  @moduledoc """
  View functions for the site's main page layout.
  """
  use StaffNotesWeb, :view

  alias StaffNotes.Accounts.User

  @typedoc """
  The application name as an atom.
  """
  @type app_name :: atom

  @typedoc """
  The link information as a tuple of the author's name and URL to link to.
  """
  @type link_info :: {String.t, String.t}

  @typedoc """
  Represents a type that may be a user or may represent nothing.
  """
  @type maybe_user :: User.t | nil

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

  * `:link_options` -- A keyword list passed as attributes to the author link `a` tag
  * All other options are applied as attributes to the containing `div` element

  ## Examples

  ```
  Phoenix.HTML.safe_to_string(LayoutView.code_with_heart(:app_name))
  #=> "<div><svg .../> with <svg .../> by <a href=\"https://example.com\">Author's Name</a></div>"
  ```
  """
  @spec code_with_heart(app_name | link_info, Keyword.t) :: Phoenix.HTML.safe
  def code_with_heart(link_info, options \\ [])

  def code_with_heart(app_name, options) when is_atom(app_name) do
    name = Application.get_env(app_name, :author_name)
    location = Application.get_env(app_name, :author_url)

    code_with_heart({name, location}, options)
  end

  def code_with_heart({name, location} = tuple, options) when is_tuple(tuple) do
    {link_options, options} = Keyword.pop(options, :link_options)
    link_options = Keyword.merge(link_options || [], to: location)

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
  Renders the link to the source repository.

  ## Options

  * `:text` -- If `:text` is true, use `GitHub` as the link text; otherwise use the [GitHub mark
    octicon][mark-github] _(defaults to `false`)_
  * All other options are passed to `Phoenix.HTML.Link.link/2`

  [mark-github]: https://octicons.github.com/icon/mark-github/
  """
  @spec github_link(atom | String.t, Keyword.t) :: Phoenix.HTML.safe
  def github_link(url, options \\ [])

  def github_link(app_name, options) when is_atom(app_name) do
    repo_url = Application.get_env(app_name, :github_url)

    github_link(repo_url, options)
  end

  def github_link(repo_url, options) when is_binary(repo_url) and is_list(options) do
    {text, options} = Keyword.pop(options, :text)
    options = Keyword.merge(options, to: repo_url)

    link(github_link_text(text), options)
  end

  defp github_link_text(true), do: "GitHub"
  defp github_link_text(_), do: octicon("mark-github")

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

  def login_button(conn, %User{} = current_user) do
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
          to_string(current_user.name),
          avatar(current_user, size: 36)
        ]
      end
    ]
  end

  @doc """
  Renders the flash content.

  ## Examples

  ```
  render_flash(@conn)
  ```
  """
  @spec render_flash(Plug.Conn.t | Map.t) :: Phoenix.HTML.safe
  def render_flash(flash_info)

  def render_flash(%Plug.Conn{} = conn), do: render_flash(get_flash(conn))
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
