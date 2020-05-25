defmodule RayTracer.TestPattern do
  @moduledoc """
  This module defines a test pattern
  """

  alias RayTracer.Color
  alias RayTracer.Matrix
  alias RayTracer.RTuple
  alias RayTracer.Pattern

  @type t :: %__MODULE__{
    transform: Matrix.matrix,
    inv_transform: Matrix.matrix
  }

  use Pattern

  defimpl Pattern.CommonProtocol do
    alias RayTracer.{RTuple, TestPattern, Color}

    @spec pattern_at(TestPattern.t, RTuple.point) :: Color.t
    def pattern_at(_pattern, point) do
      Color.new(point.values)
    end
  end
end
