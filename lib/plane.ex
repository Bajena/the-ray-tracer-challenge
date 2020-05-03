defmodule RayTracer.Plane do
  @moduledoc """
  This module defines plane operations
  """

  alias RayTracer.Shape
  use Shape

  alias RayTracer.RTuple
  alias RayTracer.Matrix
  alias RayTracer.Material
  alias RayTracer.Intersection

  @type t :: %__MODULE__{
    transform: Matrix.matrix,
    material: Material.t
  }

  import RayTracer.Constants

  @doc """
  Builds a sphere with given `center`, radius `r` and transformation matrix
  """
  @spec new(Matrix.matrix, Material.t) :: t
  def new(transform \\ Matrix.ident, material \\ Material.new) do
    %__MODULE__{transform: transform, material: material}
  end

  defimpl Shape.Shadeable do
    alias RayTracer.{Plane, RTuple, Intersection, Ray}

    @spec local_normal_at(Plane.t, RTuple.point) :: RTuple.vector
    def local_normal_at(_plane, _) do
      RTuple.vector(0, 1, 0)
    end

    @spec local_intersect(Plane.t, Ray.t) :: list(Intersection.t)
    def local_intersect(shape, object_space_ray) do
      if abs(object_space_ray.direction |> RTuple.y) < epsilon() do
        []
      else
        t = -RTuple.y(object_space_ray.origin) / RTuple.y(object_space_ray.direction)
        [Intersection.new(t, shape)]
      end
    end
  end
end
