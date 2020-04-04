defmodule RayTracer.RTuple do
  @moduledoc """
  This module wraps basic vector/point operations
  """

  import __MODULE__.Helpers

  @type t :: %__MODULE__{
    values: list()
  }
  @type vector :: t
  @type point :: t

  defstruct values: {}

  @spec sub(t, t) :: t
  def sub(a, b) do
    a |> zip_map(b, &(&1 - &2)) |> new
  end

  @spec add(t, t) :: t
  def add(a, b) do
    a |> zip_map(b, &(&1 + &2)) |> new
  end

  @spec negate(t) :: t
  def negate(a) do
    a |> map(&(-&1)) |> new
  end

  @spec mul(t, number) :: t
  def mul(a, scalar) when is_number(scalar), do: mul(scalar, a)

  @spec mul(number, t) :: t
  def mul(scalar, a) when is_number(scalar) do
    a |> map(&(&1 * scalar)) |> new
  end

  @spec div(t, number) :: t
  def div(a, scalar) do
    a |> map(&(&1 / scalar)) |> new
  end

  @spec length(vector) :: number
  def length(a), do: magnitude(a)

  @spec magnitude(vector) :: number
  def magnitude(a) do
    a |> map(&(&1 * &1)) |> Enum.sum() |> :math.sqrt
  end

  @spec normalize(t) :: t
  def normalize(v) do
    m = magnitude(v)
    v |> map(&(&1 / m)) |> new
  end

  @spec dot(t, t) :: number
  def dot(a, b) do
    a
    |> zip_map(b, &(&1 * &2))
    |> Enum.sum()
  end

  @spec cross(t, t) :: t
  def cross(a, b) do
    vector(
      y(a) * z(b) - z(a) * y(b),
      z(a) * x(b) - x(a) * z(b),
      x(a) * y(b) - y(a) * x(b)
    )
  end

  @spec point?(t) :: boolean
  def point?(v) do
    v |> w == 1.0
  end

  @spec vector?(t) :: boolean
  def vector?(v) do
    v |> w == 0.0
  end

  @spec new(tuple()) :: t
  def new(values) when is_tuple(values), do: new(Tuple.to_list(values))

  @spec new([number]) :: t
  def new(values) do
    %RayTracer.RTuple{values: values}
  end

  @spec point(number, number, number) :: point
  def point(x, y, z) do
    {x, y, z, 1.0} |> new
  end

  @spec vector(number, number, number) :: vector
  def vector(x, y, z) do
    {x, y, z, 0.0} |> new
  end

  @spec x(t) :: number
  def x(v) do
    v |> value_at(0)
  end

  @spec y(t) :: number
  def y(v) do
    v |> value_at(1)
  end

  @spec z(t) :: number
  def z(v) do
    v |> value_at(2)
  end

  @spec w(t) :: number
  def w(v) do
    v |> value_at(3)
  end

  @spec set(t, integer, number) :: t
  def set(%__MODULE__{values: values}, index, value) do
    values
    |> List.update_at(index, fn (_) -> value end)
    |> new
  end

  @spec set_w(t, number) :: t
  def set_w(t, v), do: set(t, 3, v)

  @spec value_at(t, integer) :: number
  defp value_at(%__MODULE__{values: v}, index) do
    v |> Enum.at(index)
  end
end
