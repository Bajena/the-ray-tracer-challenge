defmodule RayTracer.Color do
  alias RayTracer.RTuple

  @moduledoc """
  This module wraps color operations
  """
  defdelegate add(c1, c2), to: RTuple
  defdelegate sub(c1, c2), to: RTuple
  defdelegate mul(c1, scalar), to: RTuple
  defdelegate map(c, f), to: RTuple.Helpers

  @spec new(number, number, number) :: RTuple.t
  def new(r, g, b), do: RTuple.new({r, g, b})

  @spec new(list(number) | tuple) :: RTuple.t
  defdelegate new(values), to: RTuple

  @spec red(RTuple.t) :: number
  def red(c), do: RTuple.x(c)

  @spec green(RTuple.t) :: number
  def green(c), do: RTuple.y(c)

  @spec blue(RTuple.t) :: number
  def blue(c), do: RTuple.z(c)

  @doc """
  Returns a new color with values scaled to 0-base. Base is 255 by default.
  """
  @spec scale(RTuple.t, integer) :: number
  def scale(c, base \\ 255) do
    c
    |> clamp
    |> RTuple.Helpers.map(fn (x) -> x * base end)
    |> new
  end

  @doc """
  Returns a new color with values limited to 0-1
  """
  @spec clamp(RTuple.t) :: number
  def clamp(c) do
    c |> RTuple.Helpers.map(&clamp_value/1) |> new
  end

  @doc """
  Returns a new color - a multiplication of two input colors
  """
  @spec hadamard_product(RTuple.t, RTuple.t) :: RTuple.t
  def hadamard_product(c1, c2) do
    c1 |> RTuple.Helpers.zip_map(c2, &(&1 * &2)) |> new
  end

  defp clamp_value(v) when v < 0, do: 0
  defp clamp_value(v) when v > 1, do: 1
  defp clamp_value(v), do: v
end
