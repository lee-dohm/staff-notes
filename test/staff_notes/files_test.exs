defmodule StaffNotes.FilesTest do
  use ExUnit.Case

  alias StaffNotes.Files

  defmodule FakeSuccess do
    def request(req) do
      {:ok, req}
    end
  end

  defmodule FakeFailure do
    def request(req) do
      {:error, req}
    end
  end

  setup do
    {
      :ok,
      data: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==",
      mime_type: "image/png"
    }
  end

  test "uploading a file", context do
    {:ok, url} = Files.upload_file(context.data, context.mime_type, ex_aws_module: FakeSuccess)

    assert url =~ ~r{^https://staffnotes-io.*\.png$}
  end

  test "uploading data that isn't base64 encoded", context do
    {:error, message} = Files.upload_file("{", context.mime_type, ex_aws_module: FakeSuccess)

    assert message == "Error decoding base64 data"
  end

  test "uploading a file with a bad mime type", context do
    {:error, message} = Files.upload_file(context.data, "foo", ex_aws_module: FakeSuccess)

    assert message == "Could not determine file type"
  end

  test "failing to upload a file", context do
    {:error, _} = Files.upload_file(context.data, context.mime_type, ex_aws_module: FakeFailure)
  end
end
