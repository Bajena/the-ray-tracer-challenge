defmodule RayTracer.RTuple do
  @moduledoc """
  This module wraps basic vector/point operations
  """
  defstruct [:values]

  def sub(a, b) do
    {x(a) - x(b), y(a) - y(b), z(a) - z(b), w(a) - w(b)} |> new
  end

  def add(a, b) do
    {x(a) + x(b), y(a) + y(b), z(a) + z(b), w(a) + w(b)} |> new
  end

  def negate(a) do
    {-x(a), -y(a), -z(a), -w(a)} |> new
  end

  def mul(a, b) when is_number(b), do: mul(b, a)
  def mul(scalar, a) do
    {scalar * x(a), scalar * y(a), scalar * z(a), scalar * w(a)} |> new
  end

  def div(b, scalar) do
    {x(b) / scalar, y(b) / scalar, z(b) / scalar, w(b) / scalar} |> new
  end

  def length(a), do: magnitude(a)
  def magnitude(a) do
    Tuple.to_list(a.values) |> Enum.map(fn x -> x * x end) |> Enum.sum |> :math.sqrt
  end

  def point?(v) do
    v |> w == 1.0
  end

  def vector?(v) do
    v |> w == 0.0
  end

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

  def value_at(v, index) do
    v.values |> Kernel.elem(index)
  end
end
