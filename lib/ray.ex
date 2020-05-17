defmodule RayTracer.Ray do
  @moduledoc """
  This module defines rays and ray operations
  """

  alias RayTracer.RTuple
  alias RayTracer.Matrix

  @type t :: %__MODULE__{
    origin: RTuple.point,
    direction: RTuple.vector
  }

  defstruct [:origin, :direction]

  @doc """
  Builds a ray starting at `origin` and pointing in `direction`
  """
  @spec new(RTuple.point, RTuple.vector) :: t
  def new(origin, direction) do
    %__MODULE__{origin: origin, direction: direction}
  end

  @doc """
  Computes point at given distance t along the ray
  """
  @spec position(t, number) :: RTuple.point
  def position(ray, t) do
    distance = RTuple.mul(ray.direction, t)

    ray.origin |> RTuple.add(distance)
  end

  @doc """
  Transforms ray by applying a transformation matrix t to origin and direction
  """
  @spec transform(t, Matrix.matrix) :: t
  def transform(ray, t) do
    %__MODULE__{origin: Matrix.mult(t, ray.origin), direction: Matrix.mult(t, ray.direction)}
  end

  @doc """
  Computes a reflection of ray around a normal vector
  """
  @spec reflect(t, RTuple.vector) :: RTuple.vector
  def reflect(ray, normalv) do
    ray.direction |> RTuple.reflect(normalv)
  end
end
