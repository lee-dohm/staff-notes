defmodule StaffNotes.Accounts.OrganizationSpec do
  use ESpec

  alias StaffNotes.Accounts
  alias StaffNotes.Accounts.Organization

  import Spec.Helpers
  import ESpec.Phoenix.Assertions.Changeset.Helpers

  describe "organizations" do
    let :org, do: org_fixture()
    let :valid_attrs, do: %{name: "some name"}
    let :update_attrs, do: %{name: "some updated name"}
    let :invalid_attrs, do: %{name: nil}

    describe "change_org/1" do
      it "returns an org changeset" do
        changeset = Accounts.change_org(org())

        expect(changeset).to be_struct(Ecto.Changeset)
        expect(changeset).to be_valid()
      end
    end

    describe "create_org/1" do
      it "creates an org when given valid information" do
        expect(org().name).to eq("org name")
      end

      it "returns an error changeset when given invalid data" do
        {:error, %Ecto.Changeset{} = changeset} = Accounts.create_org(invalid_attrs())

        expect(changeset).to_not be_valid()
        expect(changeset).to have_errors(:name)
      end
    end

    describe "delete_org/1" do
      it "deletes the given org" do
        {:ok, %Organization{}} = Accounts.delete_org(org())

        expect(fn -> Accounts.get_org!(org().id) end).to raise_exception(Ecto.NoResultsError)
      end
    end

    describe "get_org!/1" do
      it "returns the org with the given id" do
        expect(Accounts.get_org!(org().id)).to eq(org())
      end

      it "raises an exception when given an invalid id" do
        expect(fn ->
          Accounts.get_org!(Ecto.UUID.generate())
        end).to raise_exception(Ecto.NoResultsError)
      end
    end

    describe "list_orgs/0" do
      it "returns all orgs" do
        org = org()
        list = Accounts.list_orgs()

        expect(list).to eq([org])
      end
    end

    describe "update_org/2" do
      it "updates the org when given valid data" do
        {:ok, updated_org} = Accounts.update_org(org(), update_attrs())

        expect(updated_org.name).to eq("some updated name")
      end

      it "returns an error changeset when given invalid data" do
        {:error, %Ecto.Changeset{} = changeset} = Accounts.update_org(org(), invalid_attrs())

        expect(changeset).to_not be_valid()
        expect(changeset).to have_errors(:name)
        expect(Accounts.get_org!(org().id)).to eq(org())
      end
    end
  end
end
