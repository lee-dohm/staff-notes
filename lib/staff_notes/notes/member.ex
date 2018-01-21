defmodule StaffNotes.Notes.Member do
  @moduledoc """
  Represents a community member that belongs to an organization.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias StaffNotes.Accounts.Organization
  alias StaffNotes.Notes.Member
  alias StaffNotes.Notes.Note

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "members" do
    field(:name, :string)

    belongs_to(:organization, Organization)
    has_many(:notes, Note)

    timestamps()
  end

  @doc false
  def changeset(%Member{} = member, attrs) do
    member
    |> cast(attrs, [:name, :organization_id])
    |> validate_required([:name, :organization_id])
    |> unique_constraint(:name, name: :members_organization_id_name_index)
  end
end
