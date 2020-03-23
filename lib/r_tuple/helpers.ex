defmodule RayTracer.RTuple.Helpers do
  @moduledoc """
  This module defines helpers for manipulating tuples
  """
  alias RayTracer.RTuple

  @spec zip_map(RTuple.t, RTuple.t, function()) :: list(number)
  def zip_map(%{values: v1}, %{values: v2}, fun) do
    v1
    |> Enum.zip(v2)
    |> Enum.map(fn {x, y} -> fun.(x, y) end)
  end

  @spec map(RTuple.t, function()) :: list(number)
  def map(%{values: v}, fun) do
    v |> Enum.map(fun)
  end
end
