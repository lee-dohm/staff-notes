defmodule StaffNotes.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias StaffNotes.Repo

  alias StaffNotes.Accounts.User
  alias StaffNotes.Accounts.Organization

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

  def create_org(attrs \\ %{}) do
    %Organization{}
    |> Organization.changeset(attrs)
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
