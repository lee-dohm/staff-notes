defmodule StaffNotesApi.ImageController do
  @moduledoc """
  Handles requests for image resources.
  """
  use StaffNotesApi, :controller

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

  defp authenticate_token(%{params: %{"token" => token}} = conn, _options) do
    case valid_token?(conn, token) do
      true -> conn
      false -> send_resp(conn, :unauthorized, "")
    end
  end

  defp authenticate_token(conn, _options) do
    conn
    |> send_resp(:unauthorized, "")
    |> halt()
  end

  defp valid_token?(conn, token) do
    conn
    |> verify_token(token)
    |> verify_user()
  end

  defp verify_token(conn, token) do
    config = Application.get_env(:staff_notes, StaffNotesWeb.Endpoint)
    salt = config[:api_access_salt]

    Phoenix.Token.verify(conn, salt, token, max_age: config[:token_max_age])
  end

  # If we can't verify the token for any reason, deny the request
  defp verify_user({:error, _}), do: false

  # Users who aren't logged in can't use the API
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
