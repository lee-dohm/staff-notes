defmodule StaffNotes.Accounts.User do
  @moduledoc """
  Represents a user of the system.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias StaffNotes.Accounts.User

  @primary_key {:id, :id, autogenerate: false}
  @foreign_key_type :id
  schema "users" do
    field :avatar_url, :string
    field :name, :string
    field :site_admin, :boolean, default: false, null: false

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :id, :avatar_url, :site_admin])
    |> validate_required([:name, :id, :avatar_url, :site_admin])
    |> unique_constraint(:name)
    |> unique_constraint(:id)
  end

  defimpl Phoenix.Param do
    def to_param(%{name: name}) do
      "#{name}"
    end
  end
end
