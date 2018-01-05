defmodule StaffNotes.Accounts.UserTest do
  use StaffNotes.DataCase

  alias StaffNotes.Accounts
  alias StaffNotes.Accounts.User

  import StaffNotes.Support.Helpers

  setup do
    {
      :ok,
      user: user_fixture()
    }
  end

  describe "list_users/0" do
    test "returns all users", context do
      assert Accounts.list_users() == [context.user]
    end
  end

  describe "list_users/1" do
    test "returns all users in an organization", context do
      org = org_fixture()
      {:ok, _} = Accounts.add_user_to_org(context.user, org)

      _other_user = user_fixture(%{name: "other name", id: 43})

      users = Accounts.list_users(org)

      assert length(users) == 1
      assert users == [context.user]
    end
  end

  describe "get_user!/1" do
    test "returns the user with the given id", context do
      assert Accounts.get_user!(context.user.id) == context.user
    end

    test "returns the user with the given user name", context do
      assert Accounts.get_user!("user name") == context.user
    end
  end

  describe "create_user/1" do
    test "creates a user when given valid data" do
      {:ok, %User{} = user} = Accounts.create_user(%{name: "some user name", id: 43, avatar_url: "url", site_admin: false})

      assert user.avatar_url == "url"
      assert user.name == "some user name"
      assert user.id == 43
      refute user.site_admin
    end

    test "returns an error changeset when given invalid data" do
      {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(%{name: nil, id: nil, avatar_url: nil, site_admin: nil})

      refute changeset.valid?
      assert errors_on(changeset).name
      assert errors_on(changeset).id
      assert errors_on(changeset).avatar_url
      assert errors_on(changeset).site_admin
    end
  end

  describe "delete_user/1" do
    test "deletes the given user", context do
      {:ok, %User{}} = Accounts.delete_user(context.user)

      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!(context.user.id)
      end
    end
  end

  describe "change_user/1" do
    test "returns a user changeset", context do
      %Ecto.Changeset{} = changeset = Accounts.change_user(context.user)

      assert changeset.valid?
    end
  end
end
