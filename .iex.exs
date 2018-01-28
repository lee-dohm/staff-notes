import_file_if_available "~/.iex.exs"

use Phoenix.HTML

import Ecto.Query
import Phoenix.HTML.Safe, only: [to_iodata: 1]

alias StaffNotes.Accounts
alias StaffNotes.Accounts.Organization
alias StaffNotes.Accounts.Team
alias StaffNotes.Accounts.User
alias StaffNotes.Ecto.Markdown
alias StaffNotes.Notes.Member
alias StaffNotes.Notes.Note
alias StaffNotes.Repo
alias StaffNotesWeb.AuthController
alias StaffNotesWeb.PageController
alias StaffNotesWeb.UserController
alias StaffNotesWeb.AvatarHelpers
alias StaffNotesWeb.ErrorView
alias StaffNotesWeb.LayoutView
alias StaffNotesWeb.PageView
alias StaffNotesWeb.Primer
alias StaffNotesWeb.UserView

import StaffNotes.IEx.Helpers
