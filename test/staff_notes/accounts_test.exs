defmodule StaffNotes.AccountsTest do
  use StaffNotes.DataCase

  alias StaffNotes.Accounts
  alias StaffNotes.Accounts.User

  import StaffNotes.Support.Helpers

  setup [:setup_regular_org]

  setup(context) do
    {
      :ok,
      org: context.regular_org,
      team: team_fixture(context.regular_org),
      user: context.regular_user
    }
  end

  describe "add_user_to_org/2" do
    test "adds the user to the given org", context do
      Accounts.add_user_to_org(context.user, context.org)
      users = Accounts.list_users(context.org)

      assert length(users) == 1
      assert context.user in users
    end

    test "adds the user to a second org", context do
      other_org = org_fixture(%{name: "other-org"})

      updated_user =
        with {:ok, user} <- Accounts.add_user_to_org(context.user, context.org),
             {:ok, user} <- Accounts.add_user_to_org(user, other_org)
        do
          Repo.preload(user, :organizations)
        end

      assert length(updated_user.organizations) == 2
      assert context.org in updated_user.organizations
      assert other_org in updated_user.organizations
    end
  end

  describe "add_user_to_team/2" do
    test "adds the user to the team", context do
      {:ok, _} = Accounts.add_user_to_team(context.user, context.team)
      users = Accounts.list_users(context.team)

      assert length(users) == 1
      assert context.user in users
    end

    test "adds the user to a second team", context do
      other_team = team_fixture(context.org)
      updated_user =
        with {:ok, user} <- Accounts.add_user_to_team(context.user, context.team),
             {:ok, user} <- Accounts.add_user_to_team(user, other_team)
        do
          Repo.preload(user, :teams)
        end

      assert length(updated_user.teams) == 2
      assert context.team in updated_user.teams
      assert other_team in updated_user.teams
    end
  end

  describe "remove_user_from_org/2" do
    setup context do
      other_user = user_fixture(%{name: "other-user", id: 43})
      other_org = org_fixture(%{name: "other-org"})

      {:ok, _} = Accounts.add_user_to_org(context.user, context.org)
      {:ok, _} = Accounts.add_user_to_org(other_user, context.org)
      {:ok, _} = Accounts.add_user_to_org(context.user, other_org)
      {:ok, _} = Accounts.add_user_to_team(context.user, context.team)

      {
        :ok,
        other_org: other_org,
        other_user: other_user
      }
    end

    test "removes the user from the org", context do
      {:ok, %User{} = user} = Accounts.remove_user_from_org(context.user, context.org)
      user = Repo.preload(user, :organizations)

      assert length(user.organizations) == 1
      assert context.other_org in user.organizations
    end

    test "returns an error changeset when the user is the last member of the org", context do
      {:error, %Ecto.Changeset{} = changeset} =
        Accounts.remove_user_from_org(context.user, context.other_org)

      refute changeset.valid?
      assert errors_on(changeset).organizations
    end

    test "removes the user from teams belonging to that organization", context do
      {:ok, %User{} = user} = Accounts.remove_user_from_org(context.user, context.org)

      assert length(user.teams) == 0
    end
  end

  describe "remove_user_from_team/2" do
    setup context do
      other_team = team_fixture(%{name: "other-team"}, context.org)
      {:ok, _} = Accounts.add_user_to_team(context.user, context.team)
      {:ok, _} = Accounts.add_user_to_team(context.user, other_team)

      {:ok, other_team: other_team}
    end

    test "removes the user from the team", context do
      {:ok, %User{} = user} = Accounts.remove_user_from_team(context.user, context.team)

      assert length(user.teams) == 1
      assert context.other_team in user.teams
    end
  end
end
