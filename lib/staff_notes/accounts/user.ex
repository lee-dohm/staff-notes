defmodule StaffNotes.Accounts.User do
  @moduledoc """
  Represents a user of the system.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias StaffNotes.Accounts.Organization
  alias StaffNotes.Accounts.Team
  alias StaffNotes.Accounts.User
  alias StaffNotes.Ecto.Slug
  alias StaffNotes.Notes.Note

  @primary_key {:id, :id, autogenerate: false}
  @foreign_key_type :id
  schema "users" do
    field(:avatar_url, :string)
    field(:name, Slug)
    field(:site_admin, :boolean, default: false, null: false)

    has_many(:notes, Note, foreign_key: :author_id)

    many_to_many(
      :organizations,
      Organization,
      join_through: "organizations_users",
      on_replace: :delete,
      on_delete: :delete_all
    )

    many_to_many(
      :teams,
      Team,
      join_through: "teams_users",
      on_replace: :delete,
      on_delete: :delete_all
    )

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :id, :avatar_url, :site_admin])
    |> validate_required([:name, :id, :avatar_url, :site_admin])
    |> unique_constraint(:id, name: :users_pkey)
  end

  defimpl Phoenix.Param do
    def to_param(%{name: name}) do
      "#{name}"
    end
  end
end
