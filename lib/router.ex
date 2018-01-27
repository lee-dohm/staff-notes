defmodule StaffNotesWeb.Router do
  @moduledoc """
  Router for the `StaffNotesWeb` application.
  """
  use StaffNotesWeb, :router

  alias Plug.Ribbon
  alias StaffNotesWeb.SlidingSessionTimeout

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(SlidingSessionTimeout)
    plug(:assign_current_user)
    plug(Ribbon, [:dev, :test])
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", StaffNotesWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/about", PageController, :about)

    resources("/users", UserController, only: [:show], param: "name")

    resources "/orgs", OrganizationController, except: [:index], param: "name" do
      resources("/members", MemberController, only: [:index, :show])
      resources("/notes", NoteController, except: [:index])
      resources("/staff", StaffController, only: [:index])
      resources("/teams", TeamController, param: "name")
    end
  end

  scope "/api", StaffNotesApi do
    pipe_through(:api)

    post("/files", FileController, :create)
    post("/markdown", MarkdownController, :render)
  end

  scope "/auth", StaffNotesWeb do
    pipe_through(:browser)

    get("/", AuthController, :index)
    get("/callback", AuthController, :callback)
    get("/logout", AuthController, :delete)
  end

  @doc """
  Fetch the current user from the session and add it to the assigns of the `Plug.Conn`.

  This allows access to the currently signed in user in views as `@current_user`. If no user is
  logged in, `@current_user` will be `nil`.
  """
  @spec assign_current_user(Plug.Conn.t(), any) :: Plug.Conn.t()
  def assign_current_user(conn, _) do
    assign(conn, :current_user, get_session(conn, :current_user))
  end
end
