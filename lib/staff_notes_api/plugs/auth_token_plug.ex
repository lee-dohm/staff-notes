defmodule StaffNotesApi.AuthTokenPlug do
  @moduledoc """
  A `Plug` for validating the API token in the authorization request header.
  """
  import Plug.Conn, only: [get_req_header: 2, halt: 1, send_resp: 3]

  alias Phoenix.Token

  alias StaffNotes.Accounts

  @doc """
  Initialize the plug with the supplied options.

  ## Options

  * `:api_access_salt` -- Salt to use when verifying the token _(default: "api-access-salt")_
  * `:max_age` -- Maximum allowable age of the token in seconds _(default: one day)_
  """
  def init(options) do
    default_options()
    |> Keyword.merge(Application.get_env(:staff_notes, __MODULE__) || [])
    |> Keyword.merge(options || [])
  end

  @doc """
  Call the plug with the initialized options.

  Looks for the token in the request `Authorization` header in the format
  `token [big-long-token-thing]`. When found, it verifies the token and the user ID of the user the
  token was issued to. If any step fails, `401 Unauthorized` is returned and the request is halted.
  """
  def call(conn, options) do
    case valid_token?(conn, options) do
      true -> conn
      false ->
        conn
        |> send_resp(:unauthorized, "")
        |> halt()
    end
  end

  @doc """
  Gets the default options.
  """
  def default_options do
    [
      api_access_salt: "api-access-salt",
      max_age: 86_400
    ]
  end

  defp valid_token?(conn, options) do
    conn
    |> verify_token(options)
    |> verify_user()
  end

  defp verify_token(conn, options) do
    case get_req_header(conn, "authorization") do
      ["token " <> token] -> Token.verify(conn, options[:api_access_salt], token, options)
      _ -> {:error, "Invalid authorization header"}
    end
  end

  # If we can't verify the token for any reason, deny the request
  defp verify_user({:error, _}), do: false

  # Users who aren't logged in can't use the API
  # TODO: We should probably log this in the future since logged out users shouldn't receive a token
  defp verify_user({:ok, nil}), do: false

  # We got a user ID, but is it real?
  defp verify_user({:ok, id}) do
    case Accounts.get_user(id) do
      nil -> false
      _ -> true
    end
  end
end
