defmodule StaffNotes.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :permission, :string
      add :original, :boolean, default: false
      add :organization_id, references(:organizations, type: :binary_id, on_delete: :nothing)

      timestamps()
    end

    create table(:teams_users, primary_key: false) do
      add :team_id, references(:teams, type: :binary_id)
      add :user_id, references(:users, type: :id)
    end

    create table(:organizations_users, primary_key: false) do
      add :organization_id, references(:organizations, type: :binary_id)
      add :user_id, references(:users, type: :id)
    end
  end
end
