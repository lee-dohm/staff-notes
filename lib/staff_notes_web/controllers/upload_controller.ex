defmodule StaffNotesWeb.UploadController do
  use StaffNotesWeb, :controller

  require Logger

  def upload_form(conn, _params) do
    render(conn, "upload.html")
  end

  def upload(conn, %{"upload" => %{"file" => file}}) do
    extension = Path.extname(file.filename)
    uuid = Ecto.UUID.generate()
    filename = "#{uuid}.#{extension}"
    bucket = "staffnotes-io"
    {:ok, binary} = File.read(file.path)

    {:ok, _} = result =
      bucket
      |> ExAws.S3.put_object(filename, binary)
      |> ExAws.request()

    Logger.debug(fn -> "File uploaded: #{inspect(result)}" end)

    conn
    |> put_flash(:info, "File uploaded successfully!")
    |> render("upload.html")
  end
end
