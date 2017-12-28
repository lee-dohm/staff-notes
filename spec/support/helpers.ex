defmodule Spec.Helpers do
  @doc """
  Merges `additional` attributes with `base`.
  """
  def merge_attrs(base, additional), do: Enum.into(additional, base)
end
