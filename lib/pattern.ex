defmodule RayTracer.Pattern do
  @moduledoc """
  This is a common module for all kinds of patterns
  """
  alias RayTracer.Color
  alias RayTracer.Shape
  alias RayTracer.Matrix
  alias RayTracer.RTuple

  @type t :: RayTracer.StripePattern.t

  defprotocol CommonProtocol do
    @doc """
    Computes the color for the pattern at the point in pattern space
    """
    def pattern_at(pattern, point)
  end

  defmacro __using__(fields \\ []) do
    base_fields = [transform: Matrix.ident]
    new_fields = base_fields ++ fields
    quote do
      defstruct unquote(new_fields)
    end
  end

  @doc """
  Computes the color for the pattern on given object at the given world space
  point with respect to the transformations on both the pattern
  and the object.
  """
  @spec pattern_at_shape(t, Shape.t, RTuple.point) :: Color.t
  def pattern_at_shape(pattern, object, position) do
    object_space_point =
      object.transform
      |> Matrix.inverse
      |> Matrix.mult(position)

    pattern_space_point =
      pattern.transform
      |> Matrix.inverse
      |> Matrix.mult(object_space_point)

    pattern_at(pattern, pattern_space_point)
  end

  @spec pattern_at(t, RTuple.point) :: Color.t
  def pattern_at(shape, point) do
    CommonProtocol.pattern_at(shape, point)
  end
end
