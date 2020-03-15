defmodule RayTracer.RTuple.Helpers do
  @moduledoc """
  This module defines helpers for manipulating tuples
  """

  def zip_map(%{values: v1}, %{values: v2}, fun) do
    Enum.zip(Tuple.to_list(v1), Tuple.to_list(v2))
    |> Enum.map(fn {x, y} -> fun.(x, y) end)
  end

  def map(%{values: v}, fun) do
    Tuple.to_list(v) |> Enum.map(fun)
  end
end

defmodule RayTracer.RTuple.CustomOperators do
  @moduledoc """
  This module defines special operators required for tuple computations
  """

  import RayTracer.RTuple.Helpers

  @doc """
  Special comparison operator - returns true if all components of both tuples
  are approximately equal (with 5 digits precision).
  """
  def a <~> b do
    round = &(Float.round(&1, 5))
    map(a, round) == map(b, round)
  end
end

defmodule RayTracer.RTuple do
  @moduledoc """
  This module wraps basic vector/point operations
  """

  import RayTracer.RTuple.Helpers
  alias __MODULE__, as: RTuple

  @type t :: %__MODULE__{
    values: tuple()
  }

  defstruct values: {}

  @spec sub(t, t) :: t
  def sub(a, b) do
    zip_map(a, b, &(&1 - &2)) |> new
  end

  @spec add(t, t) :: t
  def add(a, b) do
    zip_map(a, b, &(&1 + &2)) |> new
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

  @spec length(t) :: number
  def length(a), do: magnitude(a)

  @spec magnitude(t) :: number
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
    zip_map(a, b, &(&1 * &2)) |> Enum.sum()
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

  @spec new([number]) :: t
  def new(values) when is_list(values), do: new(List.to_tuple(values))

  @spec new(tuple()) :: t
  def new(values) do
    %RayTracer.RTuple{values: values}
  end

  @spec point(number, number, number) :: t
  def point(x, y, z) do
    {x, y, z, 1.0} |> new
  end

  @spec vector(number, number, number) :: t
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

  @spec value_at(t, integer) :: number
  defp value_at(%__MODULE__{values: v}, index) do
    v |> Kernel.elem(index)
  end
end
