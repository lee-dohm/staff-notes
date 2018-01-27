defmodule StaffNotesWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use StaffNotesWeb, :controller
      use StaffNotesWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  @typedoc """
  Parameters passed to a controller action.
  """
  @type params :: Map.t()

  @doc """
  Adds alias, import and use directives for `Phoenix.Channel` modules.
  """
  def channel do
    quote do
      use Phoenix.Channel
      import StaffNotesWeb.Gettext
    end
  end

  @doc """
  Adds alias, import and use directives for `Phoenix.Controller` modules.
  """
  def controller do
    quote do
      use Phoenix.Controller, namespace: StaffNotesWeb
      import Plug.Conn
      import StaffNotesWeb.Router.Helpers
      import StaffNotesWeb.Gettext
    end
  end

  @doc """
  Adds alias, import and use directives for modules intended to create helper functions for
  `Phoenix.View` modules.
  """
  def helper do
    quote do
      use Phoenix.HTML

      import PhoenixOcticons
      import StaffNotesWeb.Gettext
    end
  end

  @doc """
  Adds alias, import and use directives for `Phoenix.View` modules.
  """
  def view do
    quote do
      use Phoenix.View,
        root: "lib/staff_notes_web/templates",
        namespace: StaffNotesWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Built-in view helpers
      import StaffNotesWeb.Router.Helpers
      import StaffNotesWeb.ErrorHelpers
      import StaffNotesWeb.Gettext

      # Project-specific view helpers
      import PhoenixOcticons

      import StaffNotesWeb.ApiTokenHelpers
      import StaffNotesWeb.LinkHelpers
      import StaffNotesWeb.Primer
      import StaffNotesWeb.PrimerHelpers
      import StaffNotesWeb.SharedHelpers
      import StaffNotesWeb.TimeHelpers

      alias StaffNotesWeb.Primer
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
