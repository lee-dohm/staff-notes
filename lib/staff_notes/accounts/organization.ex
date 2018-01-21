defmodule StaffNotes.Accounts.Organization do
  @moduledoc """
  Represents an organization that has members who need staff notes tracked.
  """
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Ecto.Multi
  alias StaffNotes.Accounts
  alias StaffNotes.Accounts.Organization
  alias StaffNotes.Accounts.Team
  alias StaffNotes.Accounts.User
  alias StaffNotes.Ecto.Slug
  alias StaffNotes.Notes.Member
  alias StaffNotes.Notes.Note

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "organizations" do
    field(:name, Slug)

    many_to_many(:users, User, join_through: "organizations_users", on_delete: :delete_all)
    has_many(:teams, Team, on_delete: :delete_all)
    has_many(:notes, Note, on_delete: :delete_all)
    has_many(:members, Member, on_delete: :delete_all)

    timestamps()
  end

  @doc false
  def changeset(%Organization{} = organization, attrs) do
    organization
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  @doc false
  def create_org_changeset(attrs \\ %{}, %User{} = user) do
    changeset = Organization.changeset(%Organization{}, attrs)

    Multi.new()
    |> Multi.insert(:org, changeset)
    |> Multi.run(:team, fn %{org: org} ->
      Accounts.create_team(Team.original_team_attrs(), org)
    end)
    |> Multi.run(:add_user_to_org, fn %{org: org} ->
      Accounts.add_user_to_org(user, org)
    end)
    |> Multi.run(:add_user_to_team, fn %{team: team} ->
      Accounts.add_user_to_team(user, team)
    end)
  end

  def with(queryable, preload \\ [])
  def with(queryable, []), do: queryable
  def with(queryable, preload), do: from(q in queryable, preload: ^preload)

  defimpl Phoenix.Param do
    def to_param(%{name: name}) do
      "#{name}"
    end
  end
end
