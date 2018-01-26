defmodule StaffNotesWeb.ApiTokenHelpers do
  @moduledoc """
  View helper functions for dealing with API tokens.
  """
  use StaffNotesWeb, :helper

  @doc """
  Generates an API access token for the currently signed-in user.
  """
  def generate_api_token(conn) do
    config = Application.get_env(:staff_notes, StaffNotesWeb.Endpoint)
    salt = config[:api_access_salt]

    Phoenix.Token.sign(conn, salt, current_user_id(conn))
  end

  @doc """
  Renders a hidden input tag containing the currently-logged-in user's API token.
  """
  def token_hidden_input(conn) do
    tag(:input, type: "hidden", name: "_api_token", value: generate_api_token(conn))
  end

  defp current_user_id(conn) do
    case conn.assigns[:current_user] do
      nil -> nil
      user -> user.id
    end
  end
end
