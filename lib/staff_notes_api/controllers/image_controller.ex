defmodule StaffNotesApi.ImageController do
  @moduledoc """
  Handles requests for image resources.
  """
  use StaffNotesApi, :controller

  alias StaffNotes.Files

  @doc """
  Accepts a base64-encoded image, uploads it to S3, and returns the URL where it can be viewed.

  ## Accepts

  ```json
  {
    "image": "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg=="
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
  def create(conn, %{"image" => base64_data}) do
    base64_data
    |> String.trim()
    |> Files.upload_image()
    |> handle_result()
  end

  defp handle_result({:error, message}) do
    conn
    |> put_status(:bad_request)
    |> json(%{"reason" => message})
  end

  defp handle_result({:ok, url}) do
    conn
    |> put_status(:created)
    |> json(%{"url" => url})
  end
end
