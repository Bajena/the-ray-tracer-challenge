defmodule RayTracer.StripePattern do
  @moduledoc """
  This module defines stripe pattern operations
  """

  alias RayTracer.Color
  alias RayTracer.Matrix
  alias RayTracer.RTuple
  alias RayTracer.Pattern

  @type t :: %__MODULE__{
    a: Color.t,
    b: Color.t,
    transform: Matrix.matrix,
    inv_transform: Matrix.matrix
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
    alias RayTracer.{RTuple, StripePattern, Color}

    @spec pattern_at(StripePattern.t, RTuple.point) :: Color.t
    def pattern_at(pattern, point) do
      if floor(point |> RTuple.x) |> rem(2) == 0 do
        pattern.a
      else
        pattern.b
      end
    end
  end
end
