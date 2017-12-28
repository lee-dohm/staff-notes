defmodule StaffNotes.AccountsSpec do
  use ESpec

  alias StaffNotes.Accounts
  alias StaffNotes.Repo

  def org_fixture(attrs \\ %{}) do
    {:ok, org} =
      attrs
      |> Enum.into(org_attrs())
      |> Accounts.create_org()

    org
  end

  def team_fixture(attrs \\ %{}, org \\ org()) do
    {:ok, team} =
      attrs
      |> Enum.into(team_attrs())
      |> Accounts.create_team(org)

    team
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(user_attrs())
      |> Accounts.create_user()

    user
  end

  let :org_attrs, do: %{name: "org name"}
  let :team_attrs, do: %{name: "team name", permission: :write, original: false}
  let :user_attrs, do: %{avatar_url: "some avatar_url", id: 42, name: "some name", site_admin: false}

  let :org, do: org_fixture()
  let :other_org, do: org_fixture(%{name: "other org"})
  let :team, do: team_fixture(team_attrs(), org())
  let :other_team, do: team_fixture(%{name: "other team"})
  let :user, do: user_fixture()

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
end
