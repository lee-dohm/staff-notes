defmodule StaffNotes.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:text, :text)
      add(:author_id, references(:users, type: :id, on_delete: :nothing))
      add(:organization_id, references(:organizations, type: :binary_id, on_delete: :nothing))

      timestamps()
    end
  end
end
