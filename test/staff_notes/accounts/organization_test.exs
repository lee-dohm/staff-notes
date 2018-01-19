defmodule StaffNotes.Accounts.OrganizationTest do
  use StaffNotes.DataCase

  alias StaffNotes.Accounts
  alias StaffNotes.Accounts.Organization
  alias StaffNotes.Ecto.Slug

  import StaffNotes.Support.Helpers

  setup [:setup_regular_org]

  setup context do
    {
      :ok,
      invalid_attrs: %{name: nil}, org: context.regular_org, valid_attrs: %{name: "some-name"}
    }
  end

  describe "change_org/1" do
    test "returns an org changeset", context do
      changeset = %Ecto.Changeset{} = Accounts.change_org(context.org)

      assert changeset.valid?
    end
  end

  describe "create_org/1" do
    test "creates an org", context do
      {:ok, %{org: org}} = Accounts.create_org(context.valid_attrs, context.regular_user)

      assert Slug.to_string(org.name) == "some-name"
    end

    test "returns an error changeset when given invalid attributes", context do
      {:error, :org, changeset, _} =
        Accounts.create_org(context.invalid_attrs, context.regular_user)

      refute changeset.valid?
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end
  end

  describe "delete_org/1" do
    test "deletes the org", context do
      {:ok, %Organization{}} = Accounts.delete_org(context.org)

      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_org!(context.org.id)
      end
    end
  end

  describe "get_org!/1" do
    test "returns the org with the given id", context do
      assert Accounts.get_org!(context.org.name) == context.org
    end

    test "raises an exception when given an invalid id" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_org!(Ecto.UUID.generate())
      end
    end
  end

  describe "list_orgs/0" do
    test "lists all orgs", context do
      assert Accounts.list_orgs() == [context.org]
    end
  end

  describe "update_org/2" do
    test "updates the org when given valid data", context do
      {:ok, updated_org} = Accounts.update_org(context.org, %{name: "updated-name"})

      assert Slug.to_string(updated_org.name) == "updated-name"
    end

    test "returns an error changeset when given invalid data", context do
      {:error, changeset} = Accounts.update_org(context.org, %{name: nil})

      refute changeset.valid?
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end
  end
end
