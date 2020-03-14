defmodule RayTracer.RTuple do
  @moduledoc """
  This module wraps basic vector/point operations
  """
  defstruct [values: {}]

  def sub(%{values: v1}, %{values: v2}) do
    Enum.zip(Tuple.to_list(v1), Tuple.to_list(v2)) |> Enum.map(fn {a, b} -> a - b end) |> new
  end

  def add(%{values: v1}, %{values: v2}) do
    Enum.zip(Tuple.to_list(v1), Tuple.to_list(v2)) |> Enum.map(fn {a, b} -> a + b end) |> new
  end

  def negate(%{values: v}) do
    Tuple.to_list(v) |> Enum.map(&(-&1)) |> new
  end

  def mul(a, b) when is_number(b), do: mul(b, a)
  def mul(scalar, %{values: v}) do
    Tuple.to_list(v) |> Enum.map(&(&1 * scalar)) |> new
  end

  def div(%{values: v}, scalar) do
    Tuple.to_list(v) |> Enum.map(&(&1 / scalar)) |> new
  end

  def length(a), do: magnitude(a)
  def magnitude(%{values: v}) do
    Tuple.to_list(v) |> Enum.map(&(&1 * &1)) |> Enum.sum |> :math.sqrt
  end

  def normalize(v) do
    m = magnitude(v)
    Tuple.to_list(v.values) |> Enum.map(&(&1 / m)) |> new
  end

  def point?(v) do
    v |> w == 1.0
  end

  def vector?(v) do
    v |> w == 0.0
  end

  def new(values) when is_list(values), do: new(List.to_tuple(values))
  def new(values) do
    %{values: values}
  end

  def point(x, y, z) do
    {x, y, z, 1.0} |> new
  end

  def vector(x, y, z) do
    {x, y, z, 0.0} |> new
  end

  def x(v) do
    v |> value_at(0)
  end

  def y(v) do
    v |> value_at(1)
  end

  def z(v) do
    v |> value_at(2)
  end

  def w(v) do
    v |> value_at(3)
  end

  defp value_at(%{values: v}, index) do
    v |> Kernel.elem(index)
  end
end
