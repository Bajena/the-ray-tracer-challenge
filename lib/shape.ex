defmodule RayTracer.Shape do
  @moduledoc """
  This is a common module for all kinds of shapes
  """
  alias RayTracer.Matrix
  alias RayTracer.RTuple

  defprotocol Shadeable do
    def local_normal_at(shape, object_point)
    def local_intersect(shape, ray)
  end

  defmacro __using__(fields \\ []) do
    base_fields = [:transform, :material]
    new_fields = base_fields ++ fields
    quote do
      defstruct unquote(new_fields)

      def set_transform(s, t) do
        %__MODULE__{s | transform: t}
      end
    end
  end

  @type t :: RayTracer.Sphere.t | RayTracer.Plane.t

  def normal_at(shape, p) do
    tinv = Matrix.inverse(shape.transform)
    object_point = tinv |> Matrix.mult(p)

    object_normal = Shadeable.local_normal_at(shape, object_point)

    tinv
    |> Matrix.transpose
    |> Matrix.mult(object_normal)
    |> RTuple.set_w(0)
    |> RTuple.normalize
  end

  def local_normal_at(shape, point) do
    Shadeable.local_normal_at(shape, point)
  end

  def local_intersect(shape, ray) do
    Shadeable.local_intersect(shape, ray)
  end
end
