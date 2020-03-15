defmodule RayTracer.Color do
  alias RayTracer.RTuple

  @moduledoc """
  This module wraps color operations
  """
  defdelegate add(c1, c2), to: RTuple
  defdelegate sub(c1, c2), to: RTuple
  defdelegate mul(c1, scalar), to: RTuple

  def new(r, g, b), do: RTuple.new([r, g, b])
  def new(values), do: RTuple.new(values)

  def red(c), do: RTuple.x(c)
  def green(c), do: RTuple.y(c)
  def blue(c), do: RTuple.z(c)

  @doc """
  Returns a new color - a multiplication of two input colors
  """
  def hadamard_product(c1, c2) do
    RTuple.Helpers.zip_map(c1, c2, &(&1 * &2)) |> new
  end
end
