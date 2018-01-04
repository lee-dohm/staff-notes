defmodule StaffNotes.Support.Matchers do
  alias StaffNotes.Support.Matchers.Changeset

  def be_valid, do: {Changeset.BeValid, []}
  def have_errors(value), do: {Changeset.HaveErrors, value}
end
