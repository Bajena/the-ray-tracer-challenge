defmodule RayTracer.RTuple.CustomOperators do
  @moduledoc """
  This module defines special operators required for tuple computations
  """

  import RayTracer.RTuple.Helpers
  alias RayTracer.RTuple

  @doc """
  Special comparison operator - returns true if all components of both tuples
  are approximately equal (with 5 digits precision).
  """
  @spec RTuple.t <~> RTuple.t :: boolean
  def a <~> b do
    round = &(Float.round(&1, 5))
    map(a, round) == map(b, round)
  end
end
