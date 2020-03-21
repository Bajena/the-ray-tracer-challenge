defmodule MatrixTest do
  alias RayTracer.Matrix
  use ExUnit.Case
  # doctest RayTracer.Matrix

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

  test "comparing matrices" do
    m1 =
      """
      | 1    | 2     | 3     | 4     |
      | 5.5  | 6.5   | 7.5   | 8.5   |
      | 9    | 10    | 11    | 12    |
      | 13.5 | 14.5  | 15.5  | 16.5  |
      """
      |> Matrix.from_string

    m2 =
      """
      | 1    | 2     | 3     | 4     |
      | 5.5  | 6.5   | 7.5   | 8.5   |
      | 9    | 10    | 11    | 12    |
      | 13.5 | 14.5  | 15.5  | 16.5  |
      """
      |> Matrix.from_string

    m3 =
      """
      | 2    | 2     | 3     | 4     |
      | 5.5  | 6.5   | 7.5   | 8.5   |
      | 9    | 10    | 11    | 12    |
      | 13.5 | 14.5  | 15.5  | 16.5  |
      """
      |> Matrix.from_string

    assert m1 == m2
    assert m1 != m3
  end

  test "multiplying matrices" do
    m1 =
      """
      | 1 | 2 | 3 | 4 |
      | 5 | 6 | 7 | 8 |
      | 9 | 8 | 7 | 6 |
      | 5 | 4 | 3 | 2 |
      """
      |> Matrix.from_string

    m2 =
      """
      | -2 | 1 | 2 |  3 |
      |  3 | 2 | 1 | -1 |
      |  4 | 3 | 6 |  5 |
      |  1 | 2 | 7 |  8 |
      """
      |> Matrix.from_string

    m3 =
      """
      | 20 | 22 |  50 |  48 |
      | 44 | 54 | 114 | 108 |
      | 40 | 58 | 110 | 102 |
      | 16 | 26 |  46 |  42 |
      """
      |> Matrix.from_string

    assert Matrix.mult(m1, m2) == m3
  end
end
