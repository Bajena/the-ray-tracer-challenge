defmodule RayTracer.Sphere do
  @moduledoc """
  This module defines sphere operations
  """

  alias RayTracer.RTuple
  alias RayTracer.Matrix
  alias RayTracer.Material

  @type t :: %__MODULE__{
    center: RTuple.point,
    r: number,
    transform: Matrix.matrix,
    material: Material.t
  }

  defstruct [:center, :r, :transform, :material]

  @doc """
  Builds a sphere with given `center`, radius `r` and transformation matrix
  """
  @spec new(RTuple.point, number) :: t
  def new(center \\ RTuple.point(0, 0, 0), radius \\ 1, transform \\ Matrix.ident, material \\ Material.new) do
    %__MODULE__{center: center, r: radius, transform: transform, material: material}
  end

  @spec set_transform(t, Matrix.matrix) :: t
  def set_transform(s, t) do
    %__MODULE__{s | transform: t}
  end

  @spec normal_at(t, RTuple.point) :: RTuple.vector
  def normal_at(sphere, p) do
    tinv = Matrix.inverse(sphere.transform)
    object_point = tinv |> Matrix.mult(p)

    object_normal =
      object_point
      |> RTuple.sub(sphere.center)
      |> RTuple.normalize

    tinv
    |> Matrix.transpose
    |> Matrix.mult(object_normal)
    |> RTuple.set_w(0)
    |> RTuple.normalize
  end
end
