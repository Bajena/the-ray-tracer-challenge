defmodule RayTracer.GradientPattern do
  @moduledoc """
  This module defines gradient pattern operations
  """

  alias RayTracer.Color
  alias RayTracer.Matrix
  alias RayTracer.RTuple
  alias RayTracer.Pattern

  @type t :: %__MODULE__{
    a: Color.t,
    b: Color.t,
    transform: Matrix.matrix
  }

  use Pattern, [:a, :b]

  @doc """
  Builds a new pattern with colors `a` and `b`
  """
  @spec new(Color.t, Color.t, Matrix.matrix) :: t
  def new(a, b, transform \\ Matrix.ident) do
    %__MODULE__{a: a, b: b} |> Pattern.set_transform(transform)
  end

  defimpl Pattern.CommonProtocol do
    alias RayTracer.{RTuple, GradientPattern, Color}

    @spec pattern_at(GradientPattern.t, RTuple.point) :: Color.t
    def pattern_at(pattern, point) do
      distance = Color.sub(pattern.b, pattern.a)
      px = point |> RTuple.x
      fraction = px - floor(px)

      pattern.a |> Color.add(distance |> Color.mul(fraction))
    end
  end
end
