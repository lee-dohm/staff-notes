defmodule StaffNotes.NotesTest do
  use StaffNotes.DataCase

  alias StaffNotes.Notes
  alias StaffNotes.Notes.Note

  describe "notes" do
    setup [:setup_regular_user, :setup_regular_org]

    setup(context) do
      member = member_fixture(context.regular_org)
      note = note_fixture(context.regular_user, member, context.regular_org)

      {
        :ok,
        member: member,
        note: note
      }
    end

    test "list_notes/1 returns all notes for an organization", context do
      assert Notes.list_notes(context.regular_org) == [context.note]
    end

    test "get_note!/1 returns the note with given id", context do
      assert Notes.get_note!(context.note.id) == context.note
    end

    test "create_note/4 with valid data creates a note", context do
      assert context.note.text == markdown("some text")
    end

    test "create_note/4 with invalid data returns error changeset", context do
      result = Notes.create_note(
        %{text: nil},
        context.regular_user,
        context.member,
        context.regular_org
      )

      assert {:error, %Ecto.Changeset{}} = result
    end

    test "update_note/2 with valid data updates the note", context do
      assert {:ok, note} = Notes.update_note(context.note, %{text: "some updated text"})
      assert %Note{} = note
      assert note.text == markdown("some updated text", rendered: false)
    end

    test "update_note/2 with invalid data returns error changeset", context do
      assert {:error, %Ecto.Changeset{}} = Notes.update_note(context.note, %{text: nil})
      assert context.note == Notes.get_note!(context.note.id)
    end

    test "delete_note/1 deletes the note", context do
      assert {:ok, %Note{}} = Notes.delete_note(context.note)
      assert_raise Ecto.NoResultsError, fn -> Notes.get_note!(context.note.id) end
    end

    test "change_note/1 returns a note changeset", context do
      assert %Ecto.Changeset{} = Notes.change_note(context.note)
    end
  end
end
