defmodule RayTracer.Pattern do
  @moduledoc """
  This is a common module for all kinds of patterns
  """
  alias RayTracer.Color
  alias RayTracer.Shape
  alias RayTracer.Matrix
  alias RayTracer.RTuple

  @type t :: RayTracer.StripePattern.t |
             RayTracer.RingPattern.t |
             RayTracer.CheckerPattern.t |
             RayTracer.GradientPattern.t |
             RayTracer.BlendedPattern.t

  defprotocol CommonProtocol do
    @doc """
    Computes the color for the pattern at the point in pattern space
    """
    def pattern_at(pattern, position)
  end

  defprotocol CombinationProtocol do
    @fallback_to_any true
    @doc """
    Computes the color for the pattern at the point in pattern space
    """
    def pattern_at_shape(pattern, object, position)
  end

  defmacro __using__(fields \\ []) do
    base_fields = [transform: Matrix.ident, inv_transform: Matrix.ident]
    new_fields = base_fields ++ fields
    quote do
      defstruct unquote(new_fields)
    end
  end

  defimpl CombinationProtocol, for: Any do
    alias RayTracer.Color
    alias RayTracer.Shape
    alias RayTracer.Matrix
    alias RayTracer.RTuple
    alias RayTracer.Pattern
    @doc """
    Computes the color for the pattern on given object at the given world space
    point with respect to the transformations on both the pattern
    and the object.
    """
    @spec pattern_at_shape(Pattern.t, Shape.t, RTuple.point) :: Color.t
    def pattern_at_shape(pattern, object, position) do
      pattern_space_point = Pattern.pattern_space_point(pattern, object, position)
      Pattern.pattern_at(pattern, pattern_space_point)
    end
  end

  @spec pattern_at(t, RTuple.point) :: Color.t
  def pattern_at(pattern, position) do
    CommonProtocol.pattern_at(pattern, position)
  end

  @spec pattern_at_shape(t, Shape.t, RTuple.point) :: Color.t
  def pattern_at_shape(pattern, object, position) do
    CombinationProtocol.pattern_at_shape(pattern, object, position)
  end

  @doc """
  Converts the point from world space to pattern space
  """
  @spec pattern_space_point(t, Shape.t, RTuple.point) :: RTuple.point
  def pattern_space_point(pattern, object, position) do
    object_space_point =
      object.inv_transform
      |> Matrix.mult(position)

    pattern.inv_transform
    |> Matrix.mult(object_space_point)
  end

  def set_transform(pattern, transform) do
    pattern |> struct!(transform: transform, inv_transform: transform |> Matrix.inverse)
  end
end
