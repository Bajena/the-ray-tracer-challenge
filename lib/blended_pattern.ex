defmodule RayTracer.BlendedPattern do
  @moduledoc """
  This module defines blended pattern operations
  """

  alias RayTracer.Color
  alias RayTracer.Matrix
  alias RayTracer.RTuple
  alias RayTracer.Pattern

  @type t :: %__MODULE__{
    a: Pattern.t,
    b: Pattern.t,
    transform: Matrix.matrix
  }

  use Pattern, [:a, :b]

  @doc """
  Builds a new blended pattern with patterns `a` and `b`
  """
  @spec new(Pattern.t, Pattern.t, Matrix.matrix) :: t
  def new(a, b, transform \\ Matrix.ident) do
    %__MODULE__{a: a, b: b} |> Pattern.set_transform(transform)
  end

  defimpl Pattern.CombinationProtocol do
    alias RayTracer.Color
    alias RayTracer.Shape
    alias RayTracer.Matrix
    alias RayTracer.RTuple
    alias RayTracer.Pattern

    @spec pattern_at_shape(Pattern.t, Shape.t, RTuple.point) :: Color.t
    def pattern_at_shape(pattern, object, position) do
      p =
        pattern.inv_transform
        |> Matrix.mult(position)

      pspa = Pattern.pattern_space_point(pattern.a, object, p)
      pspb = Pattern.pattern_space_point(pattern.b, object, p)
      ca = Pattern.pattern_at(pattern.a, pspa)
      cb = Pattern.pattern_at(pattern.b, pspb)

      Color.new(
        (Color.red(ca) + Color.red(cb)) / 2,
        (Color.green(ca) + Color.green(cb)) / 2,
        (Color.blue(ca) + Color.blue(cb)) / 2
      )
    end
  end
end
