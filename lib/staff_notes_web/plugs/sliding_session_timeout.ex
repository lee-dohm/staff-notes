defmodule StaffNotesWeb.SlidingSessionTimeout do
  @moduledoc """
  Module `Plug` that times out the user's session after a period of inactivity.

  Because this project uses [OAuth](https://oauth.net/), our application's permissions can be
  revoked by the owner of the account and our app would never know. By periodically timing out the
  session, we force the application to re-authenticate the logged in user, thereby reaffirming that
  they still authorize our application to use their information.

  ## Options

  * `:timeout` &mdash; Number of seconds of inactivity required for the session to time out
    _(**default:** one hour or 3,600 seconds)_

  ## Examples

  Configuring in the application configuration files:

  ```
  config :staff_notes, StaffNotesWeb.SlidingSessionTimeout,
    timeout: 1_234
  ```

  Configuring when including the plug in a pipeline:

  ```
  plug(StaffNotesWeb.SlidingSessionTimeout, timeout: 1_234)
  ```
  """
  @behaviour Plug
  import Plug.Conn

  alias Phoenix.Controller
  alias StaffNotesWeb.Router

  require Logger

  @doc """
  API used by Plug to configure the session timeout.
  """
  @spec init(Keyword.t()) :: Keyword.t()
  def init(options \\ []) do
    defaults()
    |> Keyword.merge(Application.get_env(get_app(), __MODULE__) || [])
    |> Keyword.merge(options)
  end

  @doc """
  API used by Plug to invoke the session timeout check on every request.
  """
  @spec call(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t()
  def call(conn, options) do
    timeout_at = get_session(conn, :timeout_at)

    if timeout_at && now() > timeout_at do
      conn
      |> logout_user
      |> Controller.redirect(to: Router.Helpers.auth_path(conn, :index, from: conn.request_path))
      |> halt
    else
      new_timeout = calculate_timeout(options[:timeout])

      put_session(conn, :timeout_at, new_timeout)
    end
  end

  defp calculate_timeout(timeout), do: now() + timeout

  defp defaults do
    [
      timeout: 3_600
    ]
  end

  defp get_app, do: Application.get_application(__MODULE__)

  defp logout_user(conn) do
    conn
    |> clear_session
    |> configure_session([:renew])
    |> assign(:timed_out?, true)
  end

  defp now, do: DateTime.to_unix(DateTime.utc_now())
end
