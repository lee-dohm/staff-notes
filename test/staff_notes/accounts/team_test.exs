defmodule StaffNotes.Accounts.TeamTest do
  use StaffNotes.DataCase

  alias StaffNotes.Accounts
  alias StaffNotes.Accounts.Team
  alias StaffNotes.Ecto.Slug

  import StaffNotes.Support.Helpers

  setup [:setup_regular_org]

  setup(context) do
    org = context.regular_org

    {
      :ok,
      invalid_attrs: %{name: nil, permission: nil, original: nil},
      org: org,
      team: team_fixture(org),
      valid_attrs: %{name: "some-name", permission: :write, original: false}
    }
  end

  describe "change_team/1" do
    test "returns a valid team changeset", context do
      changeset = %Ecto.Changeset{} = Accounts.change_team(context.team)

      assert changeset.valid?
    end
  end

  describe "create_team/1" do
    test "creates an team", context do
      {:ok, %Team{} = team} = Accounts.create_team(context.valid_attrs, context.org)

      assert Slug.to_string(team.name) == "some-name"
      assert team.permission == :write
      refute team.original
    end

    test "returns an error changeset when given invalid attributes", context do
      {:error, changeset} = Accounts.create_team(context.invalid_attrs, context.org)

      refute changeset.valid?
      assert errors_on(changeset).name
      assert errors_on(changeset).permission
      assert errors_on(changeset).original
    end

    test "returns an error changeset when creating a second original team in the same org", context do
      {:error, %Ecto.Changeset{} = changeset} = Accounts.create_team(%{original: true}, context.org)

      refute changeset.valid?
      assert errors_on(changeset).original
    end
  end

  describe "delete_team/1" do
    test "deletes the team", context do
      {:ok, %Team{}} = Accounts.delete_team(context.team)

      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_team!(context.team.id)
      end
    end

    test "returns an error changeset when attempting to delete the original team", context do
      team = Accounts.original_team(context.org.id)
      {:error, %Ecto.Changeset{} = changeset} = Accounts.delete_team(team)

      refute changeset.valid?
      assert errors_on(changeset).original
    end
  end

  describe "get_team!/1" do
    test "returns the team with the given name", context do
      assert Accounts.get_team!(context.team.name) == context.team
    end

    test "raises an exception when given an invalid id" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_team!("no-team-named-this")
      end
    end
  end

  describe "list_teams/0" do
    test "lists all teams", context do
      original_team = Accounts.original_team(context.org.id)
      teams = Accounts.list_teams(context.org)

      assert length(teams) == 2
      assert original_team in teams
      assert context.team in teams
    end
  end

  describe "original_team/1" do
    test "returns the original team for the given organization", context do
      query =
        from t in Team,
          where: t.organization_id == ^context.org.id,
          where: t.original
      team = Repo.one(query)

      assert Accounts.original_team(context.org.id) == team
    end

    test "returns nil when there is no original team" do
      changeset = Accounts.change_org(%StaffNotes.Accounts.Organization{name: "yet-another-org"})
      {:ok, org} = Repo.insert(changeset)

      refute Accounts.original_team(org.id)
    end
  end

  describe "update_team/2" do
    test "updates the original team when given valid data", context do
      team = Accounts.original_team(context.org.id)
      {:ok, updated_team} = Accounts.update_team(team, %{name: "updated-name"})

      assert Slug.to_string(updated_team.name) == "updated-name"
      assert updated_team.permission == :owner
      assert updated_team.original
    end

    test "updates a regular team when given valid data", context do
      {:ok, updated_team} = Accounts.update_team(context.team, %{name: "updated-name"})

      assert Slug.to_string(updated_team.name) == "updated-name"
      assert updated_team.permission == :write
      refute updated_team.original
    end

    test "returns an error changeset when given invalid data", context do
      {:error, changeset} = Accounts.update_team(context.team, %{name: nil})

      refute changeset.valid?
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "returns an error changeset when trying to mark an original team as not original", context do
      team = Accounts.original_team(context.org.id)
      {:error, changeset} = Accounts.update_team(team, %{original: false})

      refute changeset.valid?
      assert %{original: ["A team's original field cannot be changed"]} = errors_on(changeset)
    end

    test "returns an error changeset when trying to mark an unoriginal team as original", context do
      {:error, changeset} = Accounts.update_team(context.team, %{original: true})

      refute changeset.valid?
      assert %{original: ["A team's original field cannot be changed"]} = errors_on(changeset)
    end

    test "returns an error changeset when trying to change permission level of original team", context do
      team = Accounts.original_team(context.org.id)
      {:error, changeset} = Accounts.update_team(team, %{permission: :read})

      refute changeset.valid?
      assert %{permission: ["Cannot change the permission level of the original team"]} = errors_on(changeset)
    end
  end
end
