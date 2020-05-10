defmodule RayTracer.Sphere do
  @moduledoc """
  This module defines sphere operations
  """

  alias RayTracer.Shape
  alias RayTracer.RTuple
  alias RayTracer.Matrix
  alias RayTracer.Material
  alias RayTracer.Intersection

  use Shape, [
    center: RTuple.point(0, 0, 0),
    r: 1
  ]

  import RTuple, only: [sub: 2, dot: 2]

  @type t :: %__MODULE__{
    center: RTuple.point,
    r: number,
    transform: Matrix.matrix,
    material: Material.t
  }

  defimpl Shape.Shadeable do
    alias RayTracer.{Sphere, RTuple, Intersection, Ray}

    @spec local_normal_at(Sphere.t, RTuple.point) :: RTuple.vector
    def local_normal_at(sphere, object_point) do
      object_point
      |> RTuple.sub(sphere.center)
      |> RTuple.normalize
    end

    @spec local_intersect(Sphere.t, Ray.t) :: list(Intersection.t)
    def local_intersect(sphere, object_space_ray) do
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
      end |> Enum.map(&Intersection.new(&1, sphere))
    end
  end

  @doc """
  Builds a sphere with given `center`, radius `r` and transformation matrix
  """
  @spec new(RTuple.point, number) :: t
  def new(center \\ RTuple.point(0, 0, 0), radius \\ 1, transform \\ Matrix.ident, material \\ Material.new) do
    %__MODULE__{center: center, r: radius, transform: transform, material: material}
  end

  @doc """
  Necessary to keep older specs passing
  """
  def normal_at(s, point) do
    Shape.normal_at(s, point)
  end
end
