defmodule StaffNotesWeb.ApiTokenHelpers do
  @moduledoc """
  View helper functions for dealing with API tokens.
  """
  use StaffNotesWeb, :helper

  alias Phoenix.Token

  alias StaffNotesApi.TokenAuthentication

  @doc """
  Generates an API access token for the currently signed-in user.
  """
  def generate_api_token(conn) do
    Token.sign(conn, TokenAuthentication.init()[:api_access_salt], current_user_id(conn))
  end

  @doc """
  Renders a `meta` tag containing the currently-logged-in user's API token.

  If nobody is logged in, no tag is rendered.
  """
  def token_meta_tag(conn) do
    case current_user_id(conn) do
      nil -> nil
      _ -> tag(:meta, name: "api-access-token", content: generate_api_token(conn))
    end
  end

  defp current_user_id(conn) do
    case conn.assigns[:current_user] do
      nil -> nil
      user -> user.id
    end
  end
end
