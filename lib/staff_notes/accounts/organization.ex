defmodule StaffNotes.Accounts.Organization do
  use Ecto.Schema

  import Ecto.Changeset

  alias StaffNotes.Accounts.{Organization, Team, User}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "organizations" do
    field :name, :string

    has_many :teams, Team
    many_to_many :users, User, join_through: "organizations_users"

    timestamps()
  end

  @doc false
  def changeset(%Organization{} = organization, attrs) do
    organization
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
