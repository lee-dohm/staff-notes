defmodule StaffNotesApi.ImageController do
  @moduledoc """
  Handles requests for image resources.
  """
  use StaffNotesApi, :controller

  alias StaffNotes.Files

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
  ```
  """
  def create(conn, %{"base64" => base64_data, "mimeType" => mime_type}) do
    result =
      base64_data
      |> String.trim()
      |> Files.upload_image(mime_type)

    handle_result(conn, result)
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
