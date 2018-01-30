defmodule StaffNotesApi.AuthenticationError do
  @moduledoc """
  Raised when API authentication fails.

  This is raised when:

  * The `Authorization` header is missing
  * The `Authorization` header isn't formatted correctly
  * The token in the header is invalid or expired
  * The user ID in the token is invalid

  This complies with the `Plug.Exception` protocol to automatically return a `401 Unauthorized` HTTP
  status and message.

  ## Examples

  Raising with the generic error message:

  ```
  iex> raise StaffNotesApi.AuthenticationError
  ** (StaffNotesApi.AuthenticationError) Authentication failed
  ```

  Raising with a custom error message:

  ```
  iex> raise StaffNotesApi.AuthenticationError, message: "Something went wrong"
  ** (StaffNotesApi.AuthenticationError) Something went wrong
  ```
  """
  defexception message: "Authentication failed", plug_status: 401
end
