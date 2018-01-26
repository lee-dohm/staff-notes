defmodule StaffNotesApi.AuthTokenPlugTest do
  use StaffNotesWeb.ConnCase
  doctest StaffNotesApi.AuthTokenPlug

  require Logger

  import StaffNotes.Support.Helpers

  alias Phoenix.Token
  alias StaffNotesApi.AuthenticationError
  alias StaffNotesApi.AuthTokenPlug

  defp put_auth_header(conn, token) do
    put_req_header(conn, "authorization", "token #{token}")
  end

  setup [:setup_regular_user]

  setup(context) do
    id = context.regular_user.id
    salt = "api-access-salt"
    token = Token.sign(@endpoint, salt, id)
    conn = put_private(context.conn, :phoenix_endpoint, @endpoint)

    {:ok, conn: conn, id: id, options: AuthTokenPlug.init(), salt: salt, valid_token: token}
  end

  describe "calling the plug" do
    test "with a valid token", context do
      conn = put_auth_header(context.conn, context.valid_token)

      assert %Plug.Conn{} = AuthTokenPlug.call(conn, context.options)
    end

    test "without an auth header", context do
      assert_raise AuthenticationError, "`Authorization` request header missing or malformed", fn ->
        AuthTokenPlug.call(context.conn, context.options)
      end
    end

    test "with an invalid auth header", context do
      conn = put_req_header(context.conn, "authorization", "foo")

      assert_raise AuthenticationError, "`Authorization` request header missing or malformed", fn ->
        AuthTokenPlug.call(conn, context.options)
      end
    end

    test "with an invalid token", context do
      conn = put_auth_header(context.conn, "foo")

      assert_raise AuthenticationError, "Authentication token is invalid", fn ->
        AuthTokenPlug.call(conn, context.options)
      end
    end

    test "with a valid token but a non-existent user", context do
      conn = put_auth_header(context.conn, Token.sign(@endpoint, context.salt, 69))

      assert_raise AuthenticationError, "Authentication token is invalid", fn ->
        AuthTokenPlug.call(conn, context.options)
      end
    end

    test "with a valid token but a logged-out user", context do
      conn = put_auth_header(context.conn, Token.sign(@endpoint, context.salt, nil))

      assert_raise AuthenticationError, "Not logged in", fn ->
        AuthTokenPlug.call(conn, context.options)
      end
    end

    test "with an expired token", context do
      conn = put_auth_header(context.conn, context.valid_token)

      assert_raise AuthenticationError, "Authentication token is expired", fn ->
        AuthTokenPlug.call(conn, AuthTokenPlug.init(max_age: -100))
      end
    end
  end
end
