defmodule RayTracer.Shape do
  @moduledoc """
  This is a common module for all kinds of shapes
  """
  alias RayTracer.Matrix
  alias RayTracer.RTuple
  alias RayTracer.Intersection
  alias RayTracer.Ray
  alias RayTracer.Material

  defprotocol Shadeable do
    def local_normal_at(shape, object_point)
    def local_intersect(shape, ray)
  end

  defmacro __using__(fields \\ []) do
    base_fields = [
      transform: quote do Matrix.ident end,
      inv_transform: quote do Matrix.ident end,
      trans_inv_transform: quote do Matrix.ident end,
      material: quote do Material.new end
    ]
    new_fields = base_fields ++ fields
    quote do
      defstruct unquote(new_fields)
    end
  end

  @type t :: RayTracer.Sphere.t | RayTracer.Plane.t | RTuple.Cube.t

  @spec normal_at(t, RTuple.point) :: RTuple.vector
  def normal_at(shape, p) do
    tinv = shape.inv_transform
    object_point = tinv |> Matrix.mult(p)

    object_normal = Shadeable.local_normal_at(shape, object_point)

    shape.trans_inv_transform
    |> Matrix.mult(object_normal)
    |> RTuple.set_w(0)
    |> RTuple.normalize
  end

  @spec local_normal_at(t, RTuple.point) :: RTuple.vector
  def local_normal_at(shape, point) do
    Shadeable.local_normal_at(shape, point)
  end

  @spec local_intersect(t, Ray.t) :: list(Intersection.t)
  def local_intersect(shape, ray) do
    Shadeable.local_intersect(shape, ray)
  end

  @spec set_transform(t, Matrix.matrix) :: t
  def set_transform(s, t) do
    tinv = Matrix.inverse(t)
    trans_inv_transform = tinv |> Matrix.transpose

    s |> struct!(transform: t, inv_transform: tinv, trans_inv_transform: trans_inv_transform)
  end
end
