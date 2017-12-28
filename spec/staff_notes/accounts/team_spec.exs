defmodule StaffNotes.Accounts.TeamSpec do
  use ESpec

  alias StaffNotes.Accounts
  alias StaffNotes.Accounts.Team

  import Spec.Helpers
  import ESpec.Phoenix.Assertions.Changeset.Helpers

  describe "teams" do
    def org_fixture(attrs) do
      {:ok, org} =
        %{}
        |> merge_attrs(attrs)
        |> Accounts.create_org()

      org
    end

    def team_fixture(attrs \\ %{}, org \\ org()) do
      {:ok, team} =
        regular_team_attrs()
        |> merge_attrs(attrs)
        |> Accounts.create_team(org)

      team
    end

    let :org, do: org_fixture(name: "org name")
    let :other_org, do: org_fixture(name: "other org name")

    let :original_team_attrs, do: Team.original_team_attrs()
    let :regular_team_attrs, do: %{name: "some name", permission: :write, original: false}
    let :other_team_attrs, do: %{name: "some other name", permission: :read, original: false}

    let :valid_attrs, do: %{name: "some name", permission: :write, original: false}
    let :update_attrs, do: %{name: "some updated name", permission: :owner, original: true}
    let :invalid_attrs, do: %{name: nil, permission: nil, original: nil}

    let :original_team, do: team_fixture(original_team_attrs())
    let :regular_team, do: team_fixture(regular_team_attrs())

    describe "change_team/1" do
      it "returns a team changeset" do
        team = team_fixture()
        changeset = Accounts.change_team(team)

        expect(changeset).to be_struct(Ecto.Changeset)
        expect(changeset).to be_valid()
      end
    end

    describe "create_team/1" do
      it "creates a team when given valid information" do
        {:ok, %Team{} = team} = Accounts.create_team(regular_team_attrs(), org())

        expect(team.name).to eq("some name")
        expect(team.permission).to eq(:write)
        expect(team.original).to be_false()
        expect(team.organization_id).to eq(org().id)
      end

      it "returns an error changeset when given invalid data" do
        {:error, %Ecto.Changeset{} = changeset} = Accounts.create_team(invalid_attrs(), org())

        expect(changeset).to_not be_valid()
        expect(changeset).to have_errors([:name, :permission, :original])
      end

      it "returns an error changeset when creating the second original team in an org" do
        _original_team = original_team()
        {:error, %Ecto.Changeset{} = changeset} = Accounts.create_team(%{original: true}, org())

        expect(changeset).to_not be_valid()
        expect(changeset).to have_errors(:original)
      end
    end

    describe "delete_team/1" do
      it "deletes the given team" do
        _original_team = original_team()
        team = team_fixture()
        {:ok, %Team{}} = Accounts.delete_team(team)

        expect(fn -> Accounts.get_team!(team.id) end).to raise_exception(Ecto.NoResultsError)
      end

      it "returns an error changeset when attempting to delete the original team" do
        {:error, %Ecto.Changeset{} = changeset} = Accounts.delete_team(original_team())

        expect(changeset).to_not be_valid()
        expect(changeset).to have_errors(:original)
      end
    end

    describe "get_team!/1" do
      it "returns the team with the given id" do
        team = regular_team()

        expect(Accounts.get_team!(team.id)).to eq(team)
      end

      it "raises an exception when given an invalid id" do
        expect(fn ->
          Accounts.get_team!(Ecto.UUID.generate())
        end).to raise_exception(Ecto.NoResultsError)
      end
    end

    describe "list_teams/1" do
      it "returns all teams belonging to the given organization" do
        _team_in_other_org = team_fixture(regular_team_attrs(), other_org())
        team = regular_team()
        list = Accounts.list_teams(org())

        expect(list).to eq([team])
      end
    end

    describe "update_team/2" do
      it "updates the original team when given valid data" do
        original_team = original_team()
        {:ok, %Team{} = team} = Accounts.update_team(original_team, %{name: "some updated name"})

        expect(team.name).to eq("some updated name")
        expect(team.permission).to eq(:owner)
        expect(team.original).to be_true()
        expect(team.organization_id).to eq(original_team.organization_id)
      end

      it "updates a regular team when given valid data" do
        regular_team = regular_team()
        {:ok, %Team{} = team} = Accounts.update_team(regular_team, %{name: "some updated name"})

        expect(team.name).to eq("some updated name")
        expect(team.permission).to eq(:write)
        expect(team.original).to be_false()
        expect(team.organization_id).to eq(regular_team.organization_id)
      end

      it "returns an error changeset when given invalid data" do
        team = regular_team()
        {:error, %Ecto.Changeset{} = changeset} = Accounts.update_team(team, invalid_attrs())

        expect(changeset).to_not be_valid()
        expect(changeset).to have_errors([:name, :permission, :original])
        expect(Accounts.get_team!(team.id)).to eq(team)
      end

      it "returns an error changeset when trying to mark original team not original" do
        team = original_team()
        {:error, %Ecto.Changeset{} = changeset} = Accounts.update_team(team, %{original: false})

        expect(changeset).to_not be_valid()
        expect(changeset).to have_errors(:original)
      end

      it "returns an error changeset when trying to mark an unoriginal team as original" do
        team = regular_team()
        {:error, %Ecto.Changeset{} = changeset} = Accounts.update_team(team, %{original: true})

        expect(changeset).to_not be_valid()
        expect(changeset).to have_errors(:original)
      end

      it "returns an error changeset when attempting to change permission level of original team" do
        team = original_team()
        {:error, %Ecto.Changeset{} = changeset} = Accounts.update_team(team, %{permission: :read})

        expect(changeset).to_not be_valid()
        expect(changeset).to have_errors(:permission)
      end
    end
  end
end
