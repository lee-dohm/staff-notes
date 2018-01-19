defmodule StaffNotes.NotesTest do
  use StaffNotes.DataCase

  alias StaffNotes.Notes
  alias StaffNotes.Notes.Note

  describe "notes" do
    setup [:setup_regular_note]

    test "list_notes/1 returns all notes for an organization", context do
      assert Notes.list_notes(context.regular_org) == [context.regular_note]
    end

    test "get_note!/1 returns the note with given id", context do
      assert Notes.get_note!(context.regular_note.id) == context.regular_note
    end

    test "create_note/3 with valid data creates a note", context do
      assert context.regular_note.text == markdown("some text")
    end

    test "create_note/3 with invalid data returns error changeset", context do
      assert {:error, %Ecto.Changeset{}} =
               Notes.create_note(%{text: nil}, context.author, context.regular_org)
    end

    test "update_note/2 with valid data updates the note", context do
      assert {:ok, note} = Notes.update_note(context.regular_note, %{text: "some updated text"})
      assert %Note{} = note
      assert note.text == markdown("some updated text", rendered: false)
    end

    test "update_note/2 with invalid data returns error changeset", context do
      assert {:error, %Ecto.Changeset{}} = Notes.update_note(context.regular_note, %{text: nil})
      assert context.regular_note == Notes.get_note!(context.regular_note.id)
    end

    test "delete_note/1 deletes the note", context do
      assert {:ok, %Note{}} = Notes.delete_note(context.regular_note)
      assert_raise Ecto.NoResultsError, fn -> Notes.get_note!(context.regular_note.id) end
    end

    test "change_note/1 returns a note changeset", context do
      assert %Ecto.Changeset{} = Notes.change_note(context.regular_note)
    end
  end
end
