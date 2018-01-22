defmodule StaffNotesWeb.UploadController do
  use StaffNotesWeb, :controller

  def upload_form(conn, _params) do
    render(conn, "upload.html")
  end

  def upload(conn, %{"upload" => %{"file" => file}}) do
    extension = Path.extname(file.filename)
    uuid = Ecto.UUID.generate()
    filename = "#{uuid}.#{extension}"
    bucket = "staffnotes-io"
    {:ok, binary} = File.read(file.path)
    {:ok, _} =
      bucket
      |> ExAws.S3.put_object(filename, binary)
      |> ExAws.request()

    conn
    |> put_flash(:info, "File uploaded successfully!")
    |> render("upload.html")
  end
end
