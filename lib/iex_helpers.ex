defmodule IExHelpers do
  @moduledoc """
  Helper functions for use in `IEx`.
  """

  @doc """
  Cleanly shuts down the local node and exits the shell.
  """
  def exit, do: System.stop()
end
