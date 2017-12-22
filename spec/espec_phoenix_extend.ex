defmodule ESpec.Phoenix.Extend do
  def model do
    quote do
      alias StaffNotes.Repo
    end
  end

  def controller do
    quote do
      alias StaffNotes
      import StaffNotesWeb.Router.Helpers

      @endpoint StaffNotes.Endpoint
    end
  end

  def view do
    quote do
      import StaffNotesWeb.Router.Helpers
    end
  end

  def channel do
    quote do
      alias StaffNotes.Repo

      @endpoint StaffNotes.Endpoint
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
