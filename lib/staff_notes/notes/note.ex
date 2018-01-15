defmodule StaffNotes.Notes.Note do
  @moduledoc """
  Represents a note about a member of the community represented by an organization.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias StaffNotes.Accounts.Organization
  alias StaffNotes.Accounts.User
  alias StaffNotes.Ecto.Markdown
  alias StaffNotes.Notes.Note

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "notes" do
    field :text, Markdown

    belongs_to :author, User
    belongs_to :organization, Organization

    timestamps()
  end

  @doc false
  def changeset(%Note{} = note, attrs) do
    note
    |> cast(attrs, [:text, :author_id, :organization_id])
    |> validate_required([:text, :author_id, :organization_id])
  end
end
