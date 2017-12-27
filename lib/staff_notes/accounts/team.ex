defmodule StaffNotes.Accounts.Team do
  @moduledoc """
  A team is a collection of users within an organization that have the same permission level.

  ## Name

  The name of the team is used to create its "slug", the text used within the URL related to the
  team. The team's slug must be unique when compared to all other team slugs within the
  organization.

  ## Permission Level

  There are three permission levels:

  * `:owner`
      * All permissions of `:write`
      * Can invite users to the organization
      * Can remove users from the organization
      * If there is only one owner, they can delete the organization
      * Can create or delete teams
      * Can rename teams
      * Can add or remove users from teams
      * Can view list of users within all teams
  * `:write`
      * All permissions of `:read`
      * Can create members
      * Can create identities
      * Can merge members
      * Can create notes
      * Can edit notes they have authored
  * `:read`
      * Can view notes
      * Can view members
      * Can view identities
      * Can view list of teams within the organization
      * Can view list of users within the organization
      * Can view list of users within teams to which the user belongs

  There can be multiple teams with the same permission level so that an organization can track
  users how they wish.

  ## Original

  The original team is special:

  * There can be only one original team
  * It cannot stop being the original team
  * It is created with `owner` permission level
  * It cannot be deleted
  * It cannot have its permission level changed
  * If the original team contains one member, they are not allowed to leave the team
  * If the original team contains one member, they are not allowed to leave the organization

  This is done so that there will always be at least one organization member that is capable of
  administrating the organization.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias StaffNotes.Accounts
  alias StaffNotes.Accounts.Organization
  alias StaffNotes.Accounts.PermissionLevel
  alias StaffNotes.Accounts.Team
  alias StaffNotes.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "teams" do
    field :name, :string
    field :permission, PermissionLevel
    field :original, :boolean

    belongs_to :organization, Organization
    many_to_many :users, User, join_through: "teams_users"

    timestamps()
  end

  @doc """
  Implements business logic for creating teams.

  * Prevents creating an original team if one already exists in the organization
  """
  def create_team_changeset(%Team{} = team, attrs \\ %{}) do
    team
    |> changeset(attrs)
    |> validate_not_creating_second_original_team()
  end

  defp validate_not_creating_second_original_team(changeset) do
    original = get_field(changeset, :original)
    org_id = get_field(changeset, :organization_id)

    if original && Accounts.original_team(org_id) do
      add_error(
        changeset,
        :original,
        "An original team already exists in this organization"
      )
    else
      changeset
    end
  end

  @doc """
  Implements business logic for updating teams.

  * Prevents changing the value of the original field
  * Prevents changing of an original team's permission level
  """
  def update_team_changeset(%Team{} = team, attrs \\ %{}) do
    team
    |> changeset(attrs)
    |> validate_original_field_unchanged()
    |> validate_original_permission()
  end

  defp validate_original_permission(changeset) do
    do_validate_original_permission(changeset, is_original_team?(changeset))
  end

  defp do_validate_original_permission(changeset, true) do
    case get_field(changeset, :permission) do
      :owner -> changeset
      _ ->
        changeset
        |> add_error(:original, "Cannot change the permission level of the original team")
    end
  end

  defp do_validate_original_permission(changeset, false), do: changeset

  defp validate_original_field_unchanged(changeset) do
    validate_original(changeset, is_original_team?(changeset))
  end

  defp is_original_team?(changeset) do
    team_id = get_field(changeset, :id)
    org_id = get_field(changeset, :organization_id)
    original = Accounts.original_team(org_id)

    team_id == original.id
  end

  defp validate_original(changeset, original) do
    change = get_change(changeset, :original)

    do_validate_original(changeset, original, change)
  end

  defp do_validate_original(changeset, true, true), do: changeset
  defp do_validate_original(changeset, false, false), do: changeset
  defp do_validate_original(changeset, _, nil), do: changeset

  defp do_validate_original(changeset, _, _) do
    changeset
    |> add_error(:original, "A team's original field cannot be changed")
  end

  @doc false
  def original_team_attrs, do: %{name: "Owners", permission: :owner, original: true}

  @doc false
  def changeset(%Team{} = team, attrs) do
    team
    |> cast(attrs, [:name, :permission, :original, :organization_id])
    |> validate_required([:name, :permission, :original, :organization_id])
    |> foreign_key_constraint(:organization_id)
  end
end
