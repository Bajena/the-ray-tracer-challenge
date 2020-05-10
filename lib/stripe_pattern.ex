defmodule RayTracer.StripePattern do
  @moduledoc """
  This module defines stripe pattern operations
  """

  alias RayTracer.Color
  alias RayTracer.Shape
  alias RayTracer.Matrix
  alias RayTracer.RTuple

  @type t :: %__MODULE__{
    a: Color.t,
    b: Color.t,
    transform: Matrix.matrix
  }

  defstruct [:a, :b, transform: Matrix.ident]

  @doc """
  Builds a new pattern with colors `a` and `b`
  """
  @spec new(Color.t, Color.t, Matrix.matrix) :: t
  def new(a, b, transform \\ Matrix.ident) do
    %__MODULE__{a: a, b: b, transform: transform}
  end

  @doc """
  Computes the color for the pattern on given object at the given world space
  point with respect to the transformations on both the pattern
  and the object.
  """
  @spec stripe_at_object(t, Shape.t, RTuple.point) :: Color.t
  def stripe_at_object(pattern, object, position) do
    object_space_point =
      object.transform
      |> Matrix.inverse
      |> Matrix.mult(position)

    pattern_space_point =
      pattern.transform
      |> Matrix.inverse
      |> Matrix.mult(object_space_point)

    stripe_at(pattern, pattern_space_point)
  end

  @doc """
  Computes the color for the pattern at the point in pattern space
  """
  @spec stripe_at(t, RTuple.point) :: Color.t
  def stripe_at(pattern, point) do
    if floor(point |> RTuple.x) |> rem(2) == 0 do
      pattern.a
    else
      pattern.b
    end
  end
end
