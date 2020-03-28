defmodule RayTracer.Transformations do
  @moduledoc """
  This module defines matrix transformations like
  scaling, shearing, rotating and translating
  """
  alias RayTracer.Matrix

  @spec translation(number, number, number) :: Matrix.matrix
  def translation(x, y, z) do
    Matrix.ident(4)
    |> Matrix.set(0, 3, x)
    |> Matrix.set(1, 3, y)
    |> Matrix.set(2, 3, z)
  end
end
