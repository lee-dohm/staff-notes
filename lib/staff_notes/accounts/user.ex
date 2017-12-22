defmodule StaffNotes.Accounts.User do
  @moduledoc """
  Represents a user of the system.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias StaffNotes.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :avatar_url, :string
    field :github_id, :integer
    field :name, :string
    field :site_admin, :boolean, default: false, null: false

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :github_id, :avatar_url, :site_admin])
    |> validate_required([:name, :github_id, :avatar_url, :site_admin])
    |> unique_constraint(:name)
    |> unique_constraint(:github_id)
  end
end
