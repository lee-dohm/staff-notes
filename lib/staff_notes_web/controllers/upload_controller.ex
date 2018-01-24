defmodule StaffNotesWeb.UploadController do
  use StaffNotesWeb, :controller

  require Logger

  alias StaffNotes.Files

  @doc """
  Renders the file upload form.
  """
  def upload_form(conn, _params) do
    render(conn, "upload.html")
  end

  @doc """
  Receives the file uploads, stores them in S3, and renders the upload form agan.
  """
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
    |> Enum.map(fn({:ok, url}) -> Logger.debug(fn -> "File uploaded to #{url}" end) end)
  end

  defp upload_file(%Plug.Upload{} = file), do: Files.upload_image(file)
end
