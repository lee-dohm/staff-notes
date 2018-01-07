defmodule StaffNotes.SlugTest do
  use ExUnit.Case, async: true

  alias StaffNotes.Slug

  defp invalid_slug, do: %Slug{text: invalid_text()}
  defp invalid_text, do: "---foo---"
  defp valid_slug, do: %Slug{text: valid_text()}
  defp valid_text, do: "foo-bar-baz"

  describe "valid?" do
    test "properly formatted struct is valid" do
      assert Slug.valid?(valid_slug())
    end

    test "improperly formatted struct is not valid" do
      refute Slug.valid?(invalid_slug())
    end

    test "empty struct is not valid" do
      refute Slug.valid?(%Slug{text: ""})
    end

    test "properly formatted string is valid" do
      assert Slug.valid?(valid_text())
    end

    test "nil is not valid" do
      refute Slug.valid?(nil)
    end
  end

  describe "String.Chars protocol" do
    test "formats a valid slug for output" do
      assert "#{valid_slug()}" == valid_text()
    end

    test "marks up an invalid slug" do
      assert "#{invalid_slug()}" == "INVALID SLUG #{invalid_text()}"
    end
  end

  describe "Phoenix.HTML.Safe protocol" do
    test "formats a valid slug for output" do
      assert Phoenix.HTML.Safe.to_iodata(valid_slug()) == valid_text()
    end

    test "marks up an invalid slug" do
      assert Phoenix.HTML.Safe.to_iodata(invalid_slug()) == "INVALID SLUG #{invalid_text()}"
    end
  end

  describe "Ecto.Type behaviour" do
    test "type is string" do
      assert Slug.type() == :string
    end

    test "casting a valid binary returns ok" do
      {:ok, %Slug{} = slug} = Slug.cast(valid_text())

      assert slug.text == valid_text()
    end

    test "casting an invalid binary returns error" do
      assert Slug.cast(invalid_text()) == :error
    end

    test "casting a valid slug returns ok" do
      {:ok, %Slug{} = slug} = Slug.cast(valid_slug())

      assert slug == valid_slug()
    end

    test "casting an invalid slug returns error" do
      assert Slug.cast(invalid_slug()) == :error
    end

    test "casting anything else returns error" do
      assert Slug.cast(42) == :error
    end

    test "loading a valid binary returns ok" do
      {:ok, %Slug{} = slug} = Slug.load(valid_text())

      assert slug.text == valid_text()
    end

    test "loading an invalid binary returns an error" do
      assert Slug.load(invalid_text()) == :error
    end

    test "loading anything else returns an error" do
      assert Slug.load(42) == :error
    end

    test "dumping a valid slug returns ok" do
      {:ok, text} = Slug.dump(valid_slug())

      assert text == valid_text()
    end

    test "dumping an invalid slug returns an error" do
      assert Slug.dump(invalid_slug()) == :error
    end

    test "dumping a valid string returns ok" do
      {:ok, text} = Slug.dump(valid_text())

      assert text == valid_text()
    end

    test "dumping an invalid string returns an error" do
      assert Slug.dump(invalid_text()) == :error
    end

    test "dumping anything else returns an error" do
      assert Slug.dump(42) == :error
    end
  end
end
