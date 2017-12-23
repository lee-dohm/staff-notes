defmodule StaffNotes.AccountsSpec do
  use ESpec

  alias StaffNotes.Accounts

  describe "users" do
    alias StaffNotes.Accounts.User

    let :valid_attrs, do: %{avatar_url: "some avatar_url", id: 42, name: "some name", site_admin: true}
    let :update_attrs, do: %{avatar_url: "some updated avatar_url", id: 43, name: "some updated name", site_admin: false}
    let :invalid_attrs, do: %{avatar_url: nil, id: nil, name: nil, site_admin: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(valid_attrs())
        |> Accounts.create_user

      user
    end

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
