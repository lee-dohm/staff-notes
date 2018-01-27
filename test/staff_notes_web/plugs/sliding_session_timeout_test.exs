defmodule StaffNotesWeb.SlidingSessionTimeoutTest do
  use StaffNotesWeb.ConnCase

  alias StaffNotesWeb.SlidingSessionTimeout

  import Plug.Test, only: [init_test_session: 2]
  import StaffNotesWeb.Router.Helpers

  def now, do: DateTime.to_unix(DateTime.utc_now())

  setup do
    {:ok, options: SlidingSessionTimeout.init()}
  end

  test "defaults" do
    defaults = SlidingSessionTimeout.init()

    assert defaults[:timeout] == 3_600
  end

  test "overriding defaults" do
    options = SlidingSessionTimeout.init(timeout: 4_000)

    assert options[:timeout] == 4_000
  end

  test "supplying additional options" do
    options = SlidingSessionTimeout.init(foo: "bar")

    assert options[:timeout] == 3_600
    assert options[:foo] == "bar"
  end

  test "when no timeout exists in the session", context do
    conn =
      context.conn
      |> init_test_session(%{})
      |> SlidingSessionTimeout.call(context.options)

    assert_in_delta(get_session(conn, :timeout_at), now() + 3_600, 2)
  end

  test "when timeout hasn't expired", context do
    conn =
      context.conn
      |> init_test_session(%{timeout_at: now() + 1_000})
      |> SlidingSessionTimeout.call(context.options)

    assert_in_delta get_session(conn, :timeout_at), now() + 3_600, 2
  end

  test "when tmeout has expired", context do
    conn =
      context.conn
      |> init_test_session(%{timeout_at: now() - 1_000, current_user: 42})
      |> SlidingSessionTimeout.call(context.options)

    assert is_nil(get_session(conn, :timeout_at))
    assert is_nil(get_session(conn, :current_user))
    assert redirected_to(conn) =~ auth_path(conn, :index)
    assert conn.assigns[:timed_out?]
  end
end
