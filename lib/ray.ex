defmodule RayTracer.Ray do
  @moduledoc """
  This module defines rays and ray operations
  """

  alias RayTracer.RTuple
  import RTuple, only: [mul: 2, add: 2]

  @type t :: %__MODULE__{
    origin: RTuple.point,
    direction: RTuple.vector
  }

  defstruct [:origin, :direction]

  @spec new(RTuple.point, RTuple.vector) :: t
  def new(origin, direction) do
    %RayTracer.Ray{origin: origin, direction: direction}
  end

  @doc """
  Computes point at given distance t along the ray
  """
  @spec position(t, number) :: RTuple.point
  def position(ray, t) do
    distance = mul(ray.direction, t)

    ray.origin |> add(distance)
  end
end
