defmodule StaffNotes.Accounts.Team do
  @moduledoc """
  A team is a collection of users within an organization that have the same permission level.

  ## Name

  The name of the team is used to create its "slug", the text used within the URL related to the
  team. The team's slug must be unique when compared to all other team slugs within the
  organization.

  ## Permission Level

  There are three permission levels:

  * `owner`
      * All permissions of `write`
      * Can invite users to the organization
      * Can remove users from the organization
      * If there is only one owner, they can delete the organization
      * Can create or delete teams
      * Can rename teams
      * Can add or remove users from teams
      * Can view list of users within all teams
  * `write`
      * All permissions of `read`
      * Can create members
      * Can create identities
      * Can merge members
      * Can create notes
      * Can edit notes they have authored
  * `read`
      * Can view notes
      * Can view members
      * Can view identities
      * Can view list of teams within the organization
      * Can view list of users within the organization
      * Can view list of users within teams to which the user belongs

  There can be multiple teams within

  ## Original

  The original team is special:

  * There can be only one original team
  * It cannot stop being the original team
  * It is created with `owner` permission level
  * It cannot be deleted
  * It cannot have its permission level changed
  * If the team contains one member, they are not allowed to leave the team
  * If the team contains one member, they are not allowed to leave the organization

  This is done so that there will always be at least one organization member that is capable of
  administrating the organization.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias StaffNotes.Accounts.Organization
  alias StaffNotes.Accounts.Team
  alias StaffNotes.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "teams" do
    field :name, :string
    field :permission, :string
    field :original, :boolean

    belongs_to :organization, Organization
    many_to_many :users, User, join_through: "teams_users"

    timestamps()
  end

  @doc false
  def original_team_attrs, do: %{name: "Owners", permission: :owners, original: true}

  @doc false
  def changeset(%Team{} = team, attrs) do
    team
    |> cast(attrs, [:name, :permission, :original, :organization_id])
    |> validate_required([:name, :permission, :original, :organization_id])
    |> foreign_key_constraint(:organization_id)
  end
end
