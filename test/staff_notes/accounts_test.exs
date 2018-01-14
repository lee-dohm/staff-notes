defmodule StaffNotes.AccountsTest do
  use StaffNotes.DataCase

  alias StaffNotes.Accounts
  alias StaffNotes.Accounts.User

  import StaffNotes.Support.Helpers

  setup [:setup_regular_org]

  setup(context) do
    other_user = user_fixture(%{name: "other-user", id: 43})
    other_org = org_fixture(%{name: "other-org"}, other_user)

    {
      :ok,
      org: context.regular_org,
      other_user: other_user,
      other_org: other_org,
      user: context.regular_user
    }
  end

  describe "add_user_to_org/2" do
    test "adds the user to the given org", context do
      {:ok, user} = Accounts.add_user_to_org(context.user, context.other_org)
      user = Repo.preload(user, :organizations)

      assert length(user.organizations) == 2
      assert context.org in user.organizations
      assert context.other_org in user.organizations
    end

    @tag :skip
    test "doesn't add the user to an org they're already in", context do
      {:ok, user} = Accounts.add_user_to_org(context.user, context.org)
      user = Repo.preload(user, :organizations)

      assert length(user.organizations) == 1
      assert context.org in user.organizations
    end
  end

  describe "add_user_to_team/2" do
    test "adds the user to the team", context do
      team = team_fixture(%{name: "other-team"}, context.org)
      {:ok, user} = Accounts.add_user_to_team(context.user, team)
      user = Repo.preload(user, :teams)

      assert length(user.teams) == 2
      assert team in user.teams
    end
  end

  describe "remove_user_from_org/2" do
    test "removes the user from the org", context do
      {:ok, %User{}} = Accounts.add_user_to_org(context.user, context.other_org)
      {:ok, %User{} = user} = Accounts.remove_user_from_org(context.user, context.other_org)
      user = Repo.preload(user, :organizations)

      assert length(user.organizations) == 1
      assert context.org in user.organizations
    end

    test "returns an error changeset when the user is the last member of the org", context do
      {:error, %Ecto.Changeset{} = changeset} =
        Accounts.remove_user_from_org(context.user, context.org)

      refute changeset.valid?
      assert errors_on(changeset).organizations
    end

    test "removes the user from teams belonging to that organization", context do
      {:ok, %User{} = user} = Accounts.remove_user_from_org(context.user, context.other_org)

      assert length(user.teams) == 1
    end
  end

  describe "remove_user_from_team/2" do
    setup context do
      other_team = team_fixture(%{name: "other-team"}, context.org)
      {:ok, _} = Accounts.add_user_to_team(context.user, other_team)

      {:ok, other_team: other_team}
    end

    test "removes the user from the team", context do
      {:ok, %User{} = user} = Accounts.remove_user_from_team(context.user, context.other_team)

      assert length(user.teams) == 1
      refute context.other_team in user.teams
    end
  end
end
