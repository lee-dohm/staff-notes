defmodule StaffNotes.Notes do
  @moduledoc """
  Represents the business-logic layer of working with the records around the staff notes.

  There are a few different record types:

  * Comments - A comment on an Identity, Member, or Note
  * Identity - Information on an identity of a member (whether GitHub, Twitter, email or IP address)
  * Members - A member of the community
  * Notes - A note on a community member
  """
  import Ecto.Query, warn: false

  alias StaffNotes.Accounts.Organization
  alias StaffNotes.Accounts.User
  alias StaffNotes.Repo
  alias StaffNotes.Notes.Member
  alias StaffNotes.Notes.Note

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking note changes.

  ## Examples

  ```
  iex> change_note(note)
  %Ecto.Changeset{source: %Note{}}
  ```
  """
  def change_note(%Note{} = note) do
    Note.changeset(note, %{})
  end

  @doc """
  Creates a note.

  ## Examples

  ```
  iex> create_note(%{field: value})
  {:ok, %Note{}}
  ```

  ```
  iex> create_note(%{field: bad_value})
  {:error, %Ecto.Changeset{}}
  ```
  """
  def create_note(attrs \\ %{}, %User{} = author, %Member{} = member, %Organization{} = org) do
    %Note{}
    |> Map.put(:author_id, author.id)
    |> Map.put(:member_id, member.id)
    |> Map.put(:organization_id, org.id)
    |> Note.changeset(attrs)
    |> Repo.insert()
  end

  def create_member(attrs \\ %{}, %Organization{} = org) do
    %Member{}
    |> Map.put(:organization_id, org.id)
    |> Member.changeset(attrs)
    |> Repo.insert()
  end

  def find_organization_member(%Organization{} = org, name) do
    Repo.get_by(Member, organization_id: org.id, name: name)
  end

  def get_member!(id) do
    Repo.get!(Member, id)
  end

  @doc """
  Deletes a Note.

  ## Examples

  ```
  iex> delete_note(note)
  {:ok, %Note{}}
  ```

  ```
  iex> delete_note(note)
  {:error, %Ecto.Changeset{}}
  ```
  """
  def delete_note(%Note{} = note) do
    Repo.delete(note)
  end

  @doc """
  Gets a single note.

  Raises `Ecto.NoResultsError` if the Note does not exist.

  ## Examples

  ```
  iex> get_note!(123)
  %Note{}
  ```

  ```
  iex> get_note!(456)
  ** (Ecto.NoResultsError)
  ```
  """
  def get_note!(id), do: Repo.get!(Note, id)

  @doc """
  Lists the notes for an organization.

  ## Examples

  ```
  iex> list_notes(org)
  [%Note{}, ...]
  ```
  """
  @spec list_notes(Organization.t() | binary) :: [Note.t()]
  def list_notes(%Organization{} = org), do: list_notes(org.id)

  def list_notes(id) do
    query = from(n in Note, where: n.organization_id == ^id)

    Repo.all(query)
  end

  @doc """
  Updates a note.

  ## Examples

  ```
  iex> update_note(note, %{field: new_value})
  {:ok, %Note{}}
  ```

  ```
  iex> update_note(note, %{field: bad_value})
  {:error, %Ecto.Changeset{}}
  ```
  """
  def update_note(%Note{} = note, attrs) do
    note
    |> Note.changeset(attrs)
    |> Repo.update()
  end
end
