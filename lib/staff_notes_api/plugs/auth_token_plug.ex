defmodule StaffNotesApi.AuthTokenPlug do
  @moduledoc """
  A module `Plug` for validating the API token in the authorization request header.

  Looks for the token in the request `Authorization` header in the format
  `token [big-long-token-thing]`. When found, it verifies the token (using
  `Phoenix.Token.verify/4`). If the token is valid, it extracts the user ID from the token and
  verifies that there is a user in the database with the given user ID. If any step fails,
  a `StaffNotesApi.AuthenticationError` is raised which causes a `401 Unauthorized` HTTP
  status to be returned with a message.

  ## Options

  * `:api_access_salt` -- Salt to use when verifying the token _(default: "api-access-salt")_
  * `:max_age` -- Maximum allowable age of the token in seconds _(default: one day or 86,400
    seconds)_
  """
  import Plug.Conn, only: [get_req_header: 2]

  require Logger

  alias Phoenix.Token

  alias StaffNotes.Accounts
  alias StaffNotesApi.AuthenticationError

  @doc """
  Initialize the plug with the supplied options.

  ## Examples

  Default options:

  ```
  iex> StaffNotesApi.AuthTokenPlug.init()
  [api_access_salt: "api-access-salt", max_age: 86_400]
  ```

  Overriding options:

  ```
  iex> StaffNotesApi.AuthTokenPlug.init(api_access_salt: "test", max_age: 1_000)
  [api_access_salt: "test", max_age: 1_000]
  ```
  """
  def init(options \\ []) do
    default_options()
    |> Keyword.merge(Application.get_env(:staff_notes, __MODULE__) || [])
    |> Keyword.merge(options)
  end

  @doc """
  Call the plug with the initialized options.
  """
  def call(conn, options), do: validate_token!(conn, options)

  defp default_options do
    [
      api_access_salt: "api-access-salt",
      max_age: 86_400
    ]
  end

  defp validate_token!(conn, options) do
    conn
    |> verify_token!(options)
    |> verify_user!()

    conn
  end

  defp verify_token!(conn, options) do
    conn
    |> get_token!(options)
    |> do_verify_token!()
  end

  defp get_token!(conn, options) do
    case get_req_header(conn, "authorization") do
      ["token " <> token] -> Token.verify(conn, options[:api_access_salt], token, options)
      _ -> raise AuthenticationError, message: "`Authorization` request header missing or malformed"
    end
  end

  defp do_verify_token!({:ok, nil}), do: raise AuthenticationError, message: "Not logged in"
  defp do_verify_token!({:ok, user_id}), do: user_id
  defp do_verify_token!({:error, reason}) do
    raise AuthenticationError, message: "Authentication token is #{reason}"
  end

  defp verify_user!(id) do
    case Accounts.get_user(id) do
      nil -> raise AuthenticationError, message: "Authentication token is invalid"
      _ -> nil
    end
  end
end
