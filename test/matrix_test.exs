defmodule MatrixTest do
  alias RayTracer.Matrix
  use ExUnit.Case
  doctest RayTracer.Matrix

  test "constructing and inspecting a 4x4 matrix" do
    m =
      """
        | 1    | 2     | 3     | 4     |
        | 5.5  | 6.5   | 7.5   | 8.5   |
        | 9    | 10    | 11    | 12    |
        | 13.5 | 14.5  | 15.5  | 16.5  |
      """
      |> Matrix.from_string

    assert m |> Matrix.elem(0,0) == 1
    assert m |> Matrix.elem(0,3) == 4
    assert m |> Matrix.elem(1,0) == 5.5
    assert m |> Matrix.elem(1,2) == 7.5
    assert m |> Matrix.elem(2,2) == 11
    assert m |> Matrix.elem(3,2) == 15.5
    assert m |> Matrix.elem(3,5) == nil
  end
end
