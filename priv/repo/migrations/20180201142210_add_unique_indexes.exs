defmodule StaffNotes.Repo.Migrations.AddUniqueIndexes do
  use Ecto.Migration

  def change do
    # Ensures that there can only be one many-to-many relationship between each pair
    create(unique_index(:organizations_users, [:organization_id, :user_id]))
    create(unique_index(:teams_users, [:team_id, :user_id]))
  end
end
