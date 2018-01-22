defmodule StaffNotes.Files do
  @moduledoc """
  Represents the business-logic layer of handling files.
  """

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
  def upload_image(base64_data) do
    case Base.decode64(base64_data) do
      :error -> {:error, "Error decoding base64 image data"}
      {:ok, binary} ->
        bucket = Application.get_env(:staff_notes, :s3_bucket)

        do_upload(bucket, binary, image_extension(binary))
    end
  end

  defp do_upload(nil, _, _), do: raise ConfigurationError, message: "No :s3_bucket configured for #{Mix.env()} in application :staff_notes"
  defp do_upload(_, _, {:error, _} = error), do: error

  defp do_upload(bucket, binary, {:ok, extension}) do
    filename = unique_filename(extension)

    {:ok, response} =
      bucket
      |> S3.put_object(filename, binary)
      |> ExAws.request()

    {:ok, "https://#{bucket}.s3.amazonaws.com/#{filename}"}
  end

  defp image_extension(<<0x47, 0x49, 0x46, _::binary>>), do: {:ok, ".gif"}
  defp image_extension(<<0xff, 0xD8, _::binary>>), do: {:ok, ".jpg"}
  defp image_extension(<<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _::binary>>), do: {:ok, ".png"}
  defp image_extension(_), do: {:error, "Could not determine file type"}

  defp unique_filename(extension) do
    Ecto.UUID.generate() <> extension
  end
end
