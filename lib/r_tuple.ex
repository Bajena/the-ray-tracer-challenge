defmodule RayTracer.RTuple do
  defstruct [:values]

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
    { x, y, z, 1.0 } |> new
  end

  def vector(x, y, z) do
    { x, y, z, 0.0 } |> new
  end

  def x(v) do
    v |> value_at(0)
  end

  def y(v) do
    v |> value_at(1)
  end

  def y(v) do
    v |> value_at(2)
  end

  def w(v) do
    v |> value_at(3)
  end

  def value_at(v, index) do
    v.values |> Kernel.elem(index)
  end
end
