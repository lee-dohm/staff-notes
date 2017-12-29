defmodule StaffNotes.AccountsSpec do
  use ESpec

  alias StaffNotes.Accounts
  alias StaffNotes.Repo

  import Spec.Helpers
  import ESpec.Phoenix.Assertions.Changeset.Helpers

  let :org, do: org_fixture()
  let :other_org, do: org_fixture(%{name: "other org"})
  let :team, do: team_fixture(team_attrs(), org())
  let :other_team, do: team_fixture(%{name: "other team"}, org())
  let :user, do: user_fixture()
  let :other_user, do: user_fixture(%{id: 43, name: "some other name"})

  describe "add_user_to_org/2" do
    it "adds the given user to the org" do
      Accounts.add_user_to_org(user(), org())
      list = Accounts.list_users(org())

      expect(list).to eq([user()])
    end

    it "adds the given user to a second org" do
      updated_user =
        with {:ok, user} <- Accounts.add_user_to_org(user(), org()),
             {:ok, user} <- Accounts.add_user_to_org(user, other_org())
        do
          Repo.preload(user, :organizations)
        end

      expect(updated_user.organizations).to have_length(2)
      expect(updated_user.organizations).to have(org())
      expect(updated_user.organizations).to have(other_org())
    end
  end

  describe "add_user_to_team/2" do
    it "adds the user to the team" do
      Accounts.add_user_to_team(user(), team())
      list = Accounts.list_users(team())

      expect(list).to eq([user()])
    end

    it "adds the given user to a second team" do
      updated_user =
        with {:ok, user} <- Accounts.add_user_to_team(user(), team()),
             {:ok, user} <- Accounts.add_user_to_team(user, other_team())
        do
          Repo.preload(user, :teams)
        end

      expect(updated_user.teams).to have_length(2)
      expect(updated_user.teams).to have(team())
      expect(updated_user.teams).to have(other_team())
    end
  end

  describe "remove_user_from_org/2" do
    before do
      Accounts.add_user_to_org(user(), org())
      Accounts.add_user_to_org(other_user(), org())
      Accounts.add_user_to_org(user(), other_org())
      Accounts.add_user_to_team(user(), team())
    end

    it "removes the user from the org" do
      {:ok, user} = Accounts.remove_user_from_org(user(), org())
      user = Repo.preload(user, :organizations)

      expect(user.organizations).to have_length(1)
      expect(user.organizations).to have(other_org())
    end

    it "returns an error changeset when the user is the last member of the org" do
      {:error, changeset} =
        Accounts.remove_user_from_org(user(), other_org())

      expect(changeset).to_not be_valid()
      expect(changeset).to have_errors(:organizations)
    end

    it "removes the user from teams belonging to that organization" do
      {:ok, user} = Accounts.remove_user_from_org(user(), org())
      user = Repo.preload(user, :teams)

      expect(user.teams).to have_length(0)
    end
  end

  describe "remove_user_from_team/2" do
    before do
      Accounts.add_user_to_team(user(), team())
      Accounts.add_user_to_team(user(), other_team())
    end

    it "removes the user from the team" do
      {:ok, user} = Accounts.remove_user_from_team(user(), team())

      expect(user.teams).to have_length(1)
      expect(user.teams).to have(other_team())
    end
  end
end
