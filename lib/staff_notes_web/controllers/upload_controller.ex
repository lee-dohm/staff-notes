defmodule StaffNotesWeb.UploadController do
  use StaffNotesWeb, :controller

  require Logger

  def upload_form(conn, _params) do
    render(conn, "upload.html")
  end

  def upload(conn, %{"upload" => %{"file" => files}}) when is_list(files) do
    upload_files(files)

    render(conn, "upload.html")
  end

  def upload(conn, %{"upload" => %{"file" => %Plug.Upload{} = file}}) do
    upload_files([file])

    render(conn, "upload.html")
  end

  defp upload_files(files) do
    files
    |> Enum.map(&(upload_file(&1)))
    |> Enum.map(fn(url) -> Logger.debug(fn -> "File uploaded to #{url}" end) end)
  end

  defp upload_file(%Plug.Upload{} = file) do
    extension = Path.extname(file.filename)
    uuid = Ecto.UUID.generate()
    filename = "#{uuid}.#{extension}"
    bucket = "staffnotes-io"
    {:ok, binary} = File.read(file.path)

    {:ok, _} =
      bucket
      |> ExAws.S3.put_object(filename, binary)
      |> ExAws.request()

    "https://#{bucket}.s3.amazonaws.com/#{filename}"
  end
end
