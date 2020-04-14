defmodule RayTracer.Intersection do
  @moduledoc """
  This module is responsible for computing ray intersections with various shapes
  """

  alias RayTracer.Sphere
  alias RayTracer.Ray
  alias RayTracer.RTuple
  alias RayTracer.Matrix
  alias RayTracer.World

  import RTuple, only: [sub: 2, dot: 2]

  @type t :: %__MODULE__{
    t: number,
    object: Sphere.t
  }

  @type computation :: %{
    t: number,
    object: Sphere.t,
    point: RTuple.point,
    eyev: RTuple.vector,
    normalv: RTuple.vector,
    inside: boolean
  }

  defstruct [:t, :object]

  @doc """
  Builds an intersection of ray with shape `s` at distance `t`
  """
  @spec new(number, Sphere.t) :: t
  def new(t, s) do
    %__MODULE__{t: t, object: s}
  end

  @doc """
  Builds an intersection of ray with shape at distance `t`
  """
  @spec intersect(Sphere.t, Ray.t) :: list(t)
  def intersect(sphere = %Sphere{}, ray = %Ray{}) do
    object_space_ray = ray |> Ray.transform(sphere.transform |> Matrix.inverse)

    sphere_to_ray = sub(object_space_ray.origin, sphere.center)
    a = dot(object_space_ray.direction, object_space_ray.direction)
    b = 2 * dot(object_space_ray.direction, sphere_to_ray)
    c = dot(sphere_to_ray, sphere_to_ray) - sphere.r

    discriminant = b * b - 4 * a * c

    if discriminant < 0 do
     []
    else
      dsqrt = :math.sqrt(discriminant)
      [(-b - dsqrt) / (2 * a), (-b + dsqrt) / (2 * a)]
    end |> Enum.map(&new(&1, sphere))
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
    normalv = intersection.object |> Sphere.normal_at(p)
    inside = inside?(normalv, eyev)

    %{
      t: intersection.t,
      object: intersection.object,
      point: p,
      eyev: eyev,
      normalv: (if inside, do: RTuple.negate(normalv), else: normalv),
      inside: inside
    }
  end

  # Tests if the intersection occured inside the object
  @spec inside?(RTuple.vector, RTuple.vector) :: boolean
  defp inside?(normalv, eyev) do
    RTuple.dot(normalv, eyev) < 0
  end
end
