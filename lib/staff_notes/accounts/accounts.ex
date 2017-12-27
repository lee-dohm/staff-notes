defmodule StaffNotes.Accounts do
  @moduledoc """
  Represents the business-logic layer of working with the various accounts in the Staff Notes
  application. There are three types of accounts in Staff Notes:

  * Organizations - Represents an organization that has members whose behavior and achievements
    need to be tracked by staff users
  * Teams - Represents a group of users with the same permission level in an organization
  * Users - Represents a staff member of an organization who will access or author notes

  Business logic specific to a particular record is typically implemented within that module. For
  example, the logic around original teams is implemented in the `StaffNotes.Accounts.Team` module.
  Business logic that involves multiple records, such as when a user creates an organization (see
  the `create_org/1` function) is implemented within this module.
  """
  import Ecto.Query, warn: false

  alias Ecto.Changeset
  alias StaffNotes.Repo
  alias StaffNotes.Accounts.Organization
  alias StaffNotes.Accounts.Team
  alias StaffNotes.Accounts.User

  @doc """
  Creates an organization.

  When an organization is created:

  1. It is created by a user
  1. The organization is created
  1. An "Owners" team is created for that organization (with "owner" permissions)
  1. The creating user is added to the organization
  1. The creating user is added to the "Owners" team

  All of this is executed in a database transaction so if any step fails, it all gets rolled back.
  """
  def create_org(attrs \\ %{}) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a team within an organization.

  Will not create a team with `original` set to `true` if one already exists within the
  organization.
  """
  def create_team(team_attrs \\ %{}, %Organization{} = org) do
    team_attrs
    |> Map.put(:organization_id, org.id)
    |> do_create_team()
  end

  defp do_create_team(attrs) when is_map(attrs) do
    %Team{}
    |> Team.create_team_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Lists all teams within the organization.
  """
  def list_teams(%Organization{} = org) do
    query =
      from team in Team,
        where: team.organization_id == ^org.id

    Repo.all(query)
  end

  @doc """
  Returns the original team for the organization, if it exists.

  This shouldn't be susceptible to race conditions so long as the original team is **always**
  created along with the organization.
  """
  def original_team(organization_id) do
    query =
      from team in Team,
      where: [original: true, organization_id: ^organization_id]

    Repo.one(query)
  end

  @doc """
  Gets the team by id.
  """
  def get_team!(id), do: Repo.get!(Team, id)

  @doc """
  Updates the team.

  Will not allow a team's `original` field to be changed.
  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.update_team_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes the team.

  Will not delete an original team.
  """
  def delete_team(%Team{original: true} = team) do
    changeset =
      team
      |> change_team()
      |> Changeset.add_error(:original, "Cannot delete the original team")

    {:error, changeset}
  end

  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Creates a changeset for the team.
  """
  def change_team(%Team{} = team) do
    Team.changeset(team, %{})
  end

  @doc """
  Returns the list of organizations.

  ## Examples

  ```
  iex> list_orgs()
  [%Organization{}, ...]
  ```
  """
  def list_orgs do
    Repo.all(Organization)
  end

  @doc """
  Returns the list of users.

  ## Examples

  ```
  iex> list_users()
  [%User{}, ...]
  ```
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single organization.

  Raises `Ecto.NoResultsError` if the organization does not exist.
  """
  def get_org!(id), do: Repo.get!(Organization, id)

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the user does not exist.

  ## Examples

  Get a user by user ID:

  ```
  iex> get_user!(123)
  %User{}
  ```

  Get a user by their user name:

  ```
  iex> get_user!("username")
  %User{}
  ```

  Attempt to get a non-existent user:

  ```
  iex> get_user!(456)
  ** (Ecto.NoResultsError)
  ```
  """
  def get_user!(binary) when is_binary(binary), do: Repo.get_by!(User, name: binary)
  def get_user!(id) when is_integer(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

  ```
  iex> create_user(%{field: value})
  {:ok, %User{}}
  ```

  ```
  iex> create_user(%{field: bad_value})
  {:error, %Ecto.Changeset{}}
  ```

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_org(%Organization{} = org, attrs) do
    org
    |> Organization.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a user.

  ## Examples

  ```
  iex> update_user(user, %{field: new_value})
  {:ok, %User{}}
  ```

  ```
  iex> update_user(user, %{field: bad_value})
  {:error, %Ecto.Changeset{}}
  ```

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_org(%Organization{} = org) do
    Repo.delete(org)
  end

  @doc """
  Deletes a user.

  ## Examples

  ```
  iex> delete_user(user)
  {:ok, %User{}}
  ```

  ```
  iex> delete_user(user)
  {:error, %Ecto.Changeset{}}
  ```

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_org(%Organization{} = org) do
    Organization.changeset(org, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

  ```
  iex> change_user(user)
  %Ecto.Changeset{source: %User{}}
  ```

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
