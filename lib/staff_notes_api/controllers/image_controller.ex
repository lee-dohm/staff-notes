defmodule StaffNotesApi.ImageController do
  @moduledoc """
  Handles requests for image resources.
  """
  use StaffNotesApi, :controller

  alias Phoenix.Token

  alias StaffNotes.Accounts
  alias StaffNotes.Files

  plug :authenticate_token

  @doc """
  Accepts a base64-encoded image, uploads it to S3, and returns the URL where it can be viewed.

  ## Accepts

  Accepts a JSON object consisting of the following:

  * `base64` &mdash; base64-encoded image data
  * `mimeType` &mdash; MIME type of the data

  ```json
  {
    "base64": "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==",
    "mimeType": "image/png"
  }
  ```

  ## Returns

  Returns status code 201 upon success:

  ```json
  {
    "url": "https://staffnotes-io.s3.amazonaws.com/be3c0fce-50d8-4fde-8ee6-484b11176da5.png"
  }
  ```

  Returns status code 400 when an error occurs:

  ```json
  {
    "reason": "An error happened"
  }

  Returns status code 401 with no body when the supplied API token is invalid.
  ```
  """
  def create(conn, %{"base64" => base64_data, "mimeType" => mime_type}) do
    result =
      base64_data
      |> String.trim()
      |> Files.upload_image(mime_type)

    handle_result(conn, result)
  end

  defp authenticate_token(conn, _options) do
    case valid_token?(conn) do
      true -> conn
      false ->
        conn
        |> send_resp(:unauthorized, "")
        |> halt()
    end
  end

  defp valid_token?(conn) do
    conn
    |> verify_token()
    |> verify_user()
  end

  defp verify_token(conn) do
    case get_req_header(conn, "authorization") do
      ["token " <> token] -> do_verify_token(conn, token)
      _ -> {:error, "Invalid authorization header"}
    end
  end

  defp do_verify_token(conn, token) do
    config = Application.get_env(:staff_notes, StaffNotesWeb.Endpoint)
    salt = config[:api_access_salt]

    Token.verify(conn, salt, token, max_age: config[:token_max_age])
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

  defp handle_result(conn, {:error, message}) do
    conn
    |> put_status(:bad_request)
    |> json(%{"reason" => message})
  end

  defp handle_result(conn, {:ok, url}) do
    conn
    |> put_status(:created)
    |> json(%{"url" => url})
  end
end
