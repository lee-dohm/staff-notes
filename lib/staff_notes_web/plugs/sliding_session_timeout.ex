defmodule StaffNotesWeb.SlidingSessionTimeout do
  @moduledoc """
  Times out the session after a period of inactivity.

  The default timeout is one hour. This can be configured in the application config where the
  timeout is given as a number of seconds.

  ```
  config :staff_notes, StaffNotesWeb.SlidingSessionTimeout,
    timeout: 1_234
  ```
  """
  import Plug.Conn

  alias Phoenix.Controller
  alias StaffNotesWeb.Router

  require Logger

  def init(options \\ []) do
    defaults()
    |> Keyword.merge(Application.get_env(get_app(), __MODULE__) || [])
    |> Keyword.merge(options)
  end

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
