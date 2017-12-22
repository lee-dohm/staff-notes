defmodule StaffNotes.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :github_id, :integer
      add :avatar_url, :string
      add :site_admin, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:users, [:name])
    create unique_index(:users, [:github_id])
  end
end
