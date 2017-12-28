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
  alias Ecto.Multi
  alias StaffNotes.Accounts
  alias StaffNotes.Accounts.Organization
  alias StaffNotes.Accounts.Team
  alias StaffNotes.Accounts.User
  alias StaffNotes.Repo

  @doc """
  Adds the user to the organization.
  """
  @spec add_user_to_org(User.t, Organization.t) :: {:ok, User.t} | {:error, Changeset.t}
  def add_user_to_org(%User{} = user, %Organization{} = org) do
    add_association_to_user(user, org, :organizations)
  end

  @doc """
  Adds the user to the team.
  """
  @spec add_user_to_team(User.t, Team.t) :: {:ok, User.t} | {:error, Changeset.t}
  def add_user_to_team(%User{} = user, %Team{} = team) do
    add_association_to_user(user, team, :teams)
  end

  defp add_association_to_user(user, item, key) do
    user = Repo.preload(user, key)
    current = Map.get(user, key)

    user
    |> Accounts.change_user()
    |> Changeset.put_assoc(key, [item | current])
    |> Repo.update()
  end

  @doc """
  Creates an `Ecto.Changeset` for tracking organization changes.
  """
  @spec change_org(Organization.t) :: Changeset.t
  def change_org(%Organization{} = org) do
    Organization.changeset(org, %{})
  end

  @doc """
  Creates an `Ecto.Changeset` for tracking team changes.

  ## Examples

  ```
  iex> change_team(team)
  %Ecto.Changeset{source: %Team{}}
  ```
  """
  @spec change_team(Team.t) :: Changeset.t
  def change_team(%Team{} = team) do
    Team.changeset(team, %{})
  end

  @doc """
  Creates an `Ecto.Changeset` for tracking user changes.

  ## Examples

  ```
  iex> change_user(user)
  %Ecto.Changeset{source: %User{}}
  ```
  """
  @spec change_user(User.t) :: Changeset.t
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

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
  @spec create_org(Map.t) :: {:ok, Organization.t} | {:error, Changeset.t}
  def create_org(attrs \\ %{}) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a team within an organization.

  See `StaffNotes.Accounts.Team.create_team_changeset/2` for applicable business rules.
  """
  @spec create_team(Map.t, Organization.t) :: {:ok, Team.t} | {:error, Changeset.t}
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
  @spec create_user(Map.t) :: {:ok, User.t} | {:error, Changeset.t}
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes the organization.
  """
  @spec delete_org(Organization.t) :: {:ok, Organization.t} | {:error, Changeset.t}
  def delete_org(%Organization{} = org) do
    Repo.delete(org)
  end

  @doc """
  Deletes the team.

  See `StaffNotes.Accounts.Team.detele_team_changeset/1` for applicable business rules.
  """
  @spec delete_team(Team.t) :: {:ok, Team.t} | {:error, Changeset.t}
  def delete_team(%Team{} = team) do
    team
    |> Team.delete_team_changeset()
    |> Repo.delete()
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
  @spec delete_user(User.t) :: {:ok, User.t} | {:error, Changeset.t}
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Gets a single organization.

  Raises `Ecto.NoResultsError` if the organization does not exist.
  """
  @spec get_org!(String.t) :: Organization.t | no_return
  def get_org!(id), do: Repo.get!(Organization, id)

  @doc """
  Gets the team by id.
  """
  @spec get_team!(String.t) :: Team.t | no_return
  def get_team!(id), do: Repo.get!(Team, id)

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
  @spec get_user!(String.t | integer) :: User.t | no_return
  def get_user!(binary) when is_binary(binary), do: Repo.get_by!(User, name: binary)
  def get_user!(id) when is_integer(id), do: Repo.get!(User, id)

  @doc """
  Returns the list of organizations.

  ## Examples

  ```
  iex> list_orgs()
  [%Organization{}, ...]
  ```
  """
  @spec list_orgs :: [Organization.t]
  def list_orgs do
    Repo.all(Organization)
  end

  @doc """
  Lists all teams within the organization.
  """
  @spec list_teams(Organization.t) :: [Team.t]
  def list_teams(%Organization{} = org) do
    query =
      from team in Team,
        where: team.organization_id == ^org.id

    Repo.all(query)
  end

  @doc """
  Returns the list of all users.

  ## Examples

  ```
  iex> list_users()
  [%User{}, ...]
  ```
  """
  @spec list_users :: [User.t]
  def list_users do
    Repo.all(User)
  end

  @doc """
  List the users in an organization.
  """
  @spec list_users(Organization.t) :: [User.t]
  def list_users(%Organization{} = org) do
    org
    |> Ecto.assoc(:users)
    |> Repo.all()
  end

  @doc """
  List the users on a team.
  """
  @spec list_users(Team.t) :: [User.t]
  def list_users(%Team{} = team) do
    team
    |> Ecto.assoc(:users)
    |> Repo.all()
  end

  @doc """
  Returns the original team for the organization, if it exists.

  This shouldn't be susceptible to race conditions so long as the original team is **always**
  created along with the organization.
  """
  @spec original_team(String.t) :: Team.t | nil
  def original_team(organization_id) do
    query =
      from team in Team,
      where: [original: true, organization_id: ^organization_id]

    Repo.one(query)
  end

  @doc """
  Removes the user from the organization.
  """
  @spec remove_user_from_org(User.t, Organization.t) :: {:ok, User.t} | {:error, Changeset.t}
  def remove_user_from_org(%User{} = user, %Organization{} = org) do
    if list_users(org) == [user] do
      user
      |> Accounts.change_user()
      |> generate_error(:organizations, "Cannot remove the last user in the organization. The organization must be deleted instead.")
    else
      org = Repo.preload(org, :teams)

      Multi.new
      |> Multi.update(:organization, remove_association_from_user_changeset(user, org, :organizations))
      |> Multi.update(:teams, remove_association_from_user_changeset(user, org.teams, :teams))
      |> Repo.transaction()
      |> case do
           {:ok, %{teams: user}} -> {:ok, user}
           {:error, _, value, _} -> {:error, value}
         end
    end
  end

  defp generate_error(changeset, key, message) do
    changeset = Changeset.add_error(changeset, key, message)

    {:error, changeset}
  end

  @doc """
  Removes the user from the team.
  """
  @spec remove_user_from_team(User.t, Team.t) :: {:ok, User.t} | {:error, Changeset.t}
  def remove_user_from_team(%User{} = user, %Team{} = team) do
    user
    |> remove_association_from_user_changeset(team, :teams)
    |> Repo.update()
  end

  defp remove_association_from_user_changeset(user, item, key) when not is_list(item) do
    remove_association_from_user_changeset(user, [item], key)
  end

  defp remove_association_from_user_changeset(user, list, key) do
    ids = Enum.map(list, &(&1.id))

    do_remove_association_from_user_changeset(user, ids, key)
  end

  defp do_remove_association_from_user_changeset(user, id_or_list, key) do
    user = Repo.preload(user, key)

    updated = remove_association_by_id(user, id_or_list, key)

    user
    |> Accounts.change_user()
    |> Changeset.put_assoc(key, updated)
  end

  defp remove_association_by_id(user, list, key) when is_list(list) do
    user
    |> Map.get(key)
    |> Enum.reject(&(&1.id in list))
  end

  defp remove_association_by_id(user, id, key) do
    user
    |> Map.get(key)
    |> Enum.reject(&(&1.id == id))
  end

  @doc """
  Updates the organization.
  """
  @spec update_org(Organization.t, Map.t) :: {:ok, Organization.t} | {:error, Changeset.t}
  def update_org(%Organization{} = org, attrs) do
    org
    |> Organization.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates the team.

  See `StaffNotes.Accounts.Team.update_team_changeset/2` for applicable business rules.
  """
  @spec update_team(Team.t, Map.t) :: {:ok, Team.t} | {:error, Changeset.t}
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.update_team_changeset(attrs)
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
  @spec update_user(User.t, Map.t) :: {:ok, User.t} | {:error, Changeset.t}
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end
end
