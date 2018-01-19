defmodule StaffNotes.Repo.Migrations.UniqueNames do
  use Ecto.Migration

  def change do
    # Ensures that each team name is unique within its organization
    create(unique_index(:teams, [:organization_id, :name]))
  end
end
