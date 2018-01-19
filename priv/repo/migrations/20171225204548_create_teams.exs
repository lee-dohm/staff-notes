defmodule StaffNotes.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  alias StaffNotes.Accounts.PermissionLevel

  def up do
    PermissionLevel.create_type()

    create table(:teams, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string)
      add(:permission, :permission_level)
      add(:original, :boolean, default: false)
      add(:organization_id, references(:organizations, type: :binary_id, on_delete: :nothing))

      timestamps()
    end

    create table(:teams_users, primary_key: false) do
      add(:team_id, references(:teams, type: :binary_id, on_delete: :delete_all))
      add(:user_id, references(:users, type: :id, on_delete: :delete_all))
    end

    create table(:organizations_users, primary_key: false) do
      add(:organization_id, references(:organizations, type: :binary_id, on_delete: :delete_all))
      add(:user_id, references(:users, type: :id, on_delete: :delete_all))
    end
  end

  def down do
    drop(table(:organizations_users))
    drop(table(:teams_users))
    drop(table(:teams))

    PermissionLevel.drop_type()
  end
end
