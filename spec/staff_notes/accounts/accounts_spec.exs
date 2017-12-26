defmodule StaffNotes.AccountsSpec do
  use ESpec

  alias StaffNotes.Repo
  alias StaffNotes.Accounts
  alias StaffNotes.Accounts.{Organization, Team, User}

  def org_fixture(attrs \\ %{}) do
    {:ok, org} =
      attrs
      |> Enum.into(valid_attrs())
      |> Accounts.create_org()

    org
  end

  def team_fixture(attrs \\ %{}, org_attrs \\ %{}) do
    org = org_fixture(org_attrs)

    {:ok, team} =
      attrs
      |> Enum.into(valid_attrs())
      |> Accounts.create_team(org)

    team
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(valid_attrs())
      |> Accounts.create_user()

    user
  end

  describe "organizations" do
    let :valid_attrs, do: %{name: "some name"}
    let :update_attrs, do: %{name: "some updated name"}
    let :invalid_attrs, do: %{name: nil}

    describe "list_orgs/0" do
      it "returns all orgs" do
        org = org_fixture()

        expect(Accounts.list_orgs()).to eq([org])
      end
    end

    describe "get_org!/1" do
      it "returns the org with the given id" do
        org = org_fixture()

        expect(Accounts.get_org!(org.id)).to eq(org)
      end

      it "raises an exception when given an invalid id" do
        expect(fn ->
          Accounts.get_org!(Ecto.UUID.generate())
        end).to raise_exception(Ecto.NoResultsError)
      end
    end

    describe "create_org/1" do
      it "creates an org when given valid information" do
        {:ok, %Organization{} = org} = Accounts.create_org(valid_attrs())

        expect(org.name).to eq("some name")
      end

      it "returns an error changeset when given invalid data" do
        {:error, changeset} = Accounts.create_org(invalid_attrs())

        expect(changeset).to be_struct(Ecto.Changeset)
      end
    end

    describe "update_org/2" do
      it "updates the org when given valid data" do
        org = org_fixture()
        {:ok, org} = Accounts.update_org(org, update_attrs())

        expect(org.name).to eq("some updated name")
      end

      it "returns an error changeset when given invalid data" do
        org = org_fixture()
        {:error, changeset} = Accounts.update_org(org, invalid_attrs())

        expect(changeset).to be_struct(Ecto.Changeset)
        expect(Accounts.get_org!(org.id)).to eq(org)
      end
    end

    describe "delete_org/1" do
      it "deletes the given org" do
        org = org_fixture()
        {:ok, %Organization{}} = Accounts.delete_org(org)

        expect(fn -> Accounts.get_org!(org.id) end).to raise_exception(Ecto.NoResultsError)
      end
    end

    describe "change_org/1" do
      it "returns a org changeset" do
        org = org_fixture()

        expect(Accounts.change_org(org)).to be_struct(Ecto.Changeset)
      end
    end
  end

  describe "teams" do
    let :valid_attrs, do: %{name: "some name", permission: "owner", original: false}
    let :update_attrs, do: %{name: "some updated name", permission: "write", original: true}
    let :invalid_attrs, do: %{name: nil, permission: nil, original: nil}

    describe "list_teams/1" do
      it "returns all teams belonging to the given organization" do
        team_fixture(%{name: "original name"}, %{name: "original org name"})
        team = team_fixture()
        %{organization: org} = Repo.preload(team, :organization)

        expect(Accounts.list_teams(org)).to eq([team])
      end
    end

    describe "get_team!/1" do
      it "returns the team with the given id" do
        team = team_fixture()

        expect(Accounts.get_team!(team.id)).to eq(team)
      end

      it "raises an exception when given an invalid id" do
        expect(fn ->
          Accounts.get_team!(Ecto.UUID.generate())
        end).to raise_exception(Ecto.NoResultsError)
      end
    end

    describe "create_team/1" do
      it "creates an team when given valid information" do
        org = org_fixture()
        {:ok, %Team{} = team} = Accounts.create_team(valid_attrs(), org)

        expect(team.name).to eq("some name")
        expect(team.permission).to eq("owner")
        expect(team.original).to be_false()
        expect(team.organization_id).to eq(org.id)
      end

      it "returns an error changeset when given invalid data" do
        org = org_fixture()
        {:error, changeset} = Accounts.create_team(invalid_attrs(), org)

        expect(changeset).to be_struct(Ecto.Changeset)
      end
    end

    describe "delete_team/1" do
      it "deletes the given team" do
        team = team_fixture()
        {:ok, %Team{}} = Accounts.delete_team(team)

        expect(fn -> Accounts.get_team!(team.id) end).to raise_exception(Ecto.NoResultsError)
      end
    end

    describe "change_team/1" do
      it "returns a team changeset" do
        team = team_fixture()

        expect(Accounts.change_team(team)).to be_struct(Ecto.Changeset)
      end
    end
  end

  describe "users" do
    let :valid_attrs, do: %{avatar_url: "some avatar_url", id: 42, name: "some name", site_admin: true}
    let :update_attrs, do: %{avatar_url: "some updated avatar_url", id: 43, name: "some updated name", site_admin: false}
    let :invalid_attrs, do: %{avatar_url: nil, id: nil, name: nil, site_admin: nil}

    describe "list_users/0" do
      it "returns all users" do
        user = user_fixture()

        expect(Accounts.list_users()).to eq([user])
      end
    end

    describe "get_user!/1" do
      it "returns the user with the given id" do
        user = user_fixture()

        expect(Accounts.get_user!(user.id)).to eq(user)
      end

      it "returns the user with the given user name" do
        user = user_fixture()

        expect(Accounts.get_user!(user.name)).to eq(user)
      end
    end

    describe "create_user/1" do
      it "creates a user when given valid data" do
        {:ok, %User{} = user} = Accounts.create_user(valid_attrs())

        expect(user.avatar_url).to eq("some avatar_url")
        expect(user.id).to eq(42)
        expect(user.name).to eq("some name")
        expect(user.site_admin).to be_true()
      end

      it "returns an error changeset when given invalid data" do
        {:error, changeset} = Accounts.create_user(invalid_attrs())

        expect(changeset).to be_struct(Ecto.Changeset)
      end
    end

    describe "update_user/2" do
      it "updates the user when given valid data" do
        user = user_fixture()
        {:ok, user} = Accounts.update_user(user, update_attrs())

        expect(user).to be_struct(User)
        expect(user.avatar_url).to eq("some updated avatar_url")
        expect(user.id).to eq(43)
        expect(user.name).to eq("some updated name")
        expect(user.site_admin).to be_false()
      end

      it "returns an error changeset when given invalid data" do
        user = user_fixture()
        {:error, changeset} = Accounts.update_user(user, invalid_attrs())

        expect(changeset).to be_struct(Ecto.Changeset)
        expect(Accounts.get_user!(user.id)).to eq(user)
      end
    end

    describe "delete_user/1" do
      it "deletes the given user" do
        user = user_fixture()
        {:ok, %User{}} = Accounts.delete_user(user)

        expect(fn -> Accounts.get_user!(user.id) end).to raise_exception(Ecto.NoResultsError)
      end
    end

    describe "change_user/1" do
      it "returns a user changeset" do
        user = user_fixture()

        expect(Accounts.change_user(user)).to be_struct(Ecto.Changeset)
      end
    end
  end
end
