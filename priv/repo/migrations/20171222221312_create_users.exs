defmodule StaffNotes.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :id, primary_key: true
      add :name, :string
      add :avatar_url, :string
      add :site_admin, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:users, [:name])
  end
end
