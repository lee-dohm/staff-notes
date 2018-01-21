defmodule StaffNotes.Repo.Migrations.AddMembersSchema do
  use Ecto.Migration

  def change do
    create table(:members, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string)
      add(:organization_id, references(:organizations, type: :binary_id, on_delete: :nothing))

      timestamps()
    end

    # Ensure member names are unique within an organization
    create(unique_index(:members, [:organization_id, :name]))

    # A note belongs to a member
    alter table(:notes) do
      add(:member_id, references(:members, type: :binary_id, on_delete: :nothing))
    end
  end
end
