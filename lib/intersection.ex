defmodule RayTracer.Intersection do
  @moduledoc """
  This module is responsible for computing ray intersections with various shapes
  """

  alias RayTracer.Shape
  alias RayTracer.Ray
  alias RayTracer.RTuple
  alias RayTracer.Matrix
  alias RayTracer.World

  import RTuple, only: [sub: 2, dot: 2]
  import RayTracer.Constants

  @type t :: %__MODULE__{
    t: number,
    object: Shape.t
  }

  @type computation :: %{
    t: number,
    object: Shape.t,
    point: RTuple.point,
    eyev: RTuple.vector,
    normalv: RTuple.vector,
    inside: boolean,
    over_point: RTuple.point
  }

  defstruct [:t, :object]

  @doc """
  Builds an intersection of ray with shape `s` at distance `t`
  """
  @spec new(number, Shape.t) :: t
  def new(t, s) do
    %__MODULE__{t: t, object: s}
  end

  @doc """
  Builds an intersection of ray with shape at distance `t`
  """
  @spec intersect(Shape.t, Ray.t) :: list(t)
  def intersect(shape, ray) do
    object_space_ray = ray |> Ray.transform(shape.transform |> Matrix.inverse)

    Shape.local_intersect(shape, object_space_ray)
  end

  @doc """
  Builds an intersection of ray with world `w`
  """
  @spec intersect_world(World.t, Ray.t) :: list(t)
  def intersect_world(world, ray) do
    world.objects
    |> Enum.flat_map(&intersect(&1, ray))
    |> Enum.sort_by(&(&1.t))
  end

  @doc """
  Returns a first non-negative intersection from intersections list
  """
  @spec hit(list(t)) :: t | nil
  def hit(intersections) do
    intersections
    |> Enum.reject(fn(i) -> i.t < 0 end)
    |> Enum.min_by(&(&1.t), fn -> nil end)
  end

  @doc """
  Prepares data for shading computations
  """
  @spec prepare_computations(t, Ray.t) :: computation
  def prepare_computations(intersection, ray) do
    p = ray |> Ray.position(intersection.t)
    eyev = RTuple.negate(ray.direction)
    normalv = intersection.object |> Shape.normal_at(p)
    inside = inside?(normalv, eyev)
    final_normal_v = (if inside, do: RTuple.negate(normalv), else: normalv)

    %{
      t: intersection.t,
      object: intersection.object,
      point: p,
      eyev: eyev,
      normalv: final_normal_v,
      inside: inside,
      over_point: p |> RTuple.add(final_normal_v |> RTuple.mul(epsilon())),
      reflectv: ray |> Ray.reflect(final_normal_v)
    }
  end

  # Tests if the intersection occured inside the object
  @spec inside?(RTuple.vector, RTuple.vector) :: boolean
  defp inside?(normalv, eyev) do
    RTuple.dot(normalv, eyev) < 0
  end
end
