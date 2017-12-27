defmodule StaffNotes.Accounts.OrganizationSpec do
  use ESpec

  alias StaffNotes.Accounts
  alias StaffNotes.Accounts.Organization

  def org_fixture(attrs \\ %{}) do
    {:ok, org} =
      attrs
      |> Enum.into(valid_attrs())
      |> Accounts.create_org()

    org
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
end
