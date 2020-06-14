defmodule RayTracer.Cube do
  @moduledoc """
  This module defines cube operations
  """

  alias RayTracer.Shape
  use Shape

  alias RayTracer.RTuple
  alias RayTracer.Matrix
  alias RayTracer.Material
  alias RayTracer.Intersection

  @type t :: %__MODULE__{
    transform: Matrix.matrix,
    inv_transform: Matrix.matrix,
    trans_inv_transform: Matrix.matrix,
    material: Material.t
  }

  import RayTracer.Constants

  @doc """
  Builds a cube with given transformation matrix and material
  """
  @spec new(Matrix.matrix, Material.t) :: t
  def new(transform \\ Matrix.ident, material \\ Material.new) do
    %__MODULE__{material: material} |> Shape.set_transform(transform)
  end

  defimpl Shape.Shadeable do
    alias RayTracer.{Cube, RTuple, Intersection, Ray}

    @spec local_normal_at(Cube.t, RTuple.point) :: RTuple.vector
    def local_normal_at(_plane, _) do
      # RTuple.vector(0, 1, 0)
    end

    @spec local_intersect(Cube.t, Ray.t) :: list(Intersection.t)
    def local_intersect(cube, ray) do
      {xtmin, xtmax} = check_axis(ray.origin |> RTuple.x, ray.direction |> RTuple.x)

      {ytmin, ytmax} = check_axis(ray.origin |> RTuple.y, ray.direction |> RTuple.y)

      {ztmin, ztmax} = check_axis(ray.origin |> RTuple.z, ray.direction |> RTuple.z)

      tmin = Enum.max([xtmin, ytmin, ztmin])
      tmax = Enum.min([xtmax, ytmax, ztmax])

      [Intersection.new(tmin, cube), Intersection.new(tmax, cube)]
    end

    @spec check_axis(number, number) :: {number, number}
    defp check_axis(origin, direction) do
      tmin_numerator = (-1 - origin)
      tmax_numerator = (1 - origin)

      if abs(direction) >= epsilon() do
        tmin = tmin_numerator / direction
        tmax = tmax_numerator / direction

        if tmin > tmax do
          {tmax, tmin}
        else
          {tmin, tmax}
        end
      else
        tmin = tmin_numerator * infinity()
        tmax = tmax_numerator * infinity()

        if tmin > tmax do
          {tmax, tmin}
        else
          {tmin, tmax}
        end
      end
    end
  end
end
