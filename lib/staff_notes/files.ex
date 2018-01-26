defmodule StaffNotes.Files do
  @moduledoc """
  Represents the business-logic layer of handling files.
  """
  require Logger

  alias ExAws.S3
  alias StaffNotes.ConfigurationError

  @doc """
  Accepts a Base64-encoded image and uploads it to S3.

  ## Examples

  ```
  iex> upload_image(...)
  "https://image_bucket.s3.amazonaws.com/dbaaee81609747ba82bea2453cc33b83.png"
  ```
  """
  @spec upload_image(String.t, String.t) :: {:ok, String.t} | {:error, String.t} | no_return()
  def upload_image(base64_data, mime_type) when is_binary(base64_data) and is_binary(mime_type) do
    case Base.decode64(base64_data) do
      :error -> {:error, "Error decoding base64 image data"}
      {:ok, binary} -> do_upload(config(:s3_bucket), binary, image_extension(mime_type))
    end
  end

  defp config(key, default \\ nil) do
    Keyword.get(
      Application.get_env(:staff_notes, __MODULE__),
      key,
      default
    )
  end

  defp do_upload(nil, _, _), do: raise ConfigurationError, message: "No :s3_bucket configured for #{Mix.env()} in application :staff_notes"
  defp do_upload(_, _, {:error, _} = error), do: error

  defp do_upload(bucket, binary, {:ok, extension}) do
    filename = Path.join(config(:base_path, ""), unique_filename(extension))

    {:ok, result} =
      bucket
      |> S3.put_object(filename, binary)
      |> ExAws.request()

    url = Path.join("https://#{bucket}.s3.amazonaws.com", filename)

    Logger.debug(fn -> "S3 upload result: #{inspect(result)}" end)
    Logger.debug(fn -> "File uploaded: #{url}" end)

    {:ok, url}
  end

  defp image_extension("image/gif"), do: {:ok, ".gif"}
  defp image_extension("image/jpeg"), do: {:ok, ".jpg"}
  defp image_extension("image/png"), do: {:ok, ".png"}
  defp image_extension(_), do: {:error, "Could not determine file type"}

  defp unique_filename(extension) do
    Ecto.UUID.generate() <> extension
  end
end
