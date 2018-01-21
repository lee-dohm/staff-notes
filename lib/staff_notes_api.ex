defmodule StaffNotesApi do
  @moduledoc """
  The entrypoint for defining REST API handlers.
  """

  @doc """
  Adds alias, import and use directives for `Phoenix.Controller` modules.
  """
  def controller do
    quote do
      use Phoenix.Controller, namespace: StaffNotesApi
      import Plug.Conn
      import StaffNotesWeb.Router.Helpers
      import StaffNotesWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
