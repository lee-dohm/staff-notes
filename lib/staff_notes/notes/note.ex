defmodule StaffNotes.Notes.Note do
  @moduledoc """
  Represents a note about a member of the community represented by an organization.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias StaffNotes.Accounts.Organization
  alias StaffNotes.Ecto.Markdown
  alias StaffNotes.Notes.Note

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "notes" do
    field :text, Markdown

    belongs_to :organization, Organization

    timestamps()
  end

  @doc false
  def changeset(%Note{} = note, attrs) do
    note
    |> cast(attrs, [:text, :organization_id])
    |> validate_required([:text, :organization_id])
  end
end
