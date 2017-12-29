defmodule StaffNotes.Accounts.UserSpec do
  use ESpec

  alias Ecto.Changeset
  alias StaffNotes.Accounts
  alias StaffNotes.Accounts.User

  import Spec.Helpers
  import ESpec.Phoenix.Assertions.Changeset.Helpers

  describe "users" do
    let :user, do: user_fixture()

    let :valid_attrs, do: %{avatar_url: "some avatar_url", id: 42, name: "some name", site_admin: true}
    let :update_attrs, do: %{avatar_url: "some updated avatar_url", id: 43, name: "some updated name", site_admin: true}
    let :invalid_attrs, do: %{avatar_url: nil, id: nil, name: nil, site_admin: nil}

    describe "list_users/0" do
      it "returns all users" do
        user = user()

        expect(Accounts.list_users()).to eq([user])
      end
    end

    describe "get_user!/1" do
      it "returns the user with the given id" do
        user = user()

        expect(Accounts.get_user!(user.id)).to eq(user)
      end

      it "returns the user with the given user name" do
        user = user()

        expect(Accounts.get_user!(user.name)).to eq(user)
      end
    end

    describe "create_user/1" do
      it "creates a user when given valid data" do
        {:ok, %User{} = user} = Accounts.create_user(user_attrs())

        expect(user.avatar_url).to eq("some avatar_url")
        expect(user.id).to eq(42)
        expect(user.name).to eq("user name")
        expect(user.site_admin).to be_false()
      end

      it "returns an error changeset when given invalid data" do
        {:error, %Changeset{} = changeset} = Accounts.create_user(invalid_attrs())

        expect(changeset).to_not be_valid()
        expect(changeset).to have_errors(Map.keys(user_attrs()))
      end
    end

    describe "update_user/2" do
      it "updates the user when given valid data" do
        {:ok, user} = Accounts.update_user(user(), update_attrs())

        expect(user).to be_struct(User)
        expect(user.avatar_url).to eq("some updated avatar_url")
        expect(user.id).to eq(43)
        expect(user.name).to eq("some updated name")
        expect(user.site_admin).to be_true()
      end

      it "returns an error changeset when given invalid data" do
        {:error, %Changeset{} = changeset} = Accounts.update_user(user(), invalid_attrs())

        expect(changeset).to_not be_valid()
        expect(changeset).to have_errors(Map.keys(user_attrs()))
      end
    end

    describe "delete_user/1" do
      it "deletes the given user" do
        {:ok, %User{} = user} = Accounts.delete_user(user())

        expect(fn -> Accounts.get_user!(user.id) end).to raise_exception(Ecto.NoResultsError)
      end
    end

    describe "change_user/1" do
      it "returns a user changeset" do
        changeset = Accounts.change_user(user())

        expect(changeset).to be_struct(Changeset)
        expect(changeset).to be_valid()
      end
    end
  end
end
