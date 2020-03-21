defmodule MatrixTest do
  alias RayTracer.Matrix
  alias RayTracer.RTuple
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

  test "A matrix multiplied by a tuple" do
    m =
      """
      | 1 | 2 | 3 | 4 |
      | 2 | 4 | 4 | 2 |
      | 8 | 6 | 4 | 1 |
      | 0 | 0 | 0 | 1 |
      """
      |> Matrix.from_string

    t = RTuple.new([1, 2, 3, 1])

    assert Matrix.mult(m, t) == RTuple.new([18, 24, 33, 1])
  end

  test "multiplying a matrix by an identity matrix" do
    m1 =
      """
      | 0 | 1 |  2 |  4 |
      | 1 | 2 |  4 |  8 |
      | 2 | 4 |  8 | 16 |
      | 4 | 8 | 16 | 32 |
      """
      |> Matrix.from_string

    m2 = Matrix.ident(4)

    assert Matrix.mult(m1, m2) == m1
  end

  test "Multiplying the identity matrix by a tuple" do
    m = Matrix.ident(4)
    t = RTuple.new([1, 2, 3, 4])

    assert Matrix.mult(m, t) == t
  end

  test "Transposing a matrix" do
    m =
      """
      | 0 | 9 | 3 | 0 |
      | 9 | 8 | 0 | 8 |
      | 1 | 8 | 5 | 3 |
      | 0 | 0 | 5 | 8 |
      """
      |> Matrix.from_string

    t =
      """
      | 0 | 9 | 1 | 0 |
      | 9 | 8 | 8 | 0 |
      | 3 | 0 | 5 | 5 |
      | 0 | 8 | 3 | 8 |
      """
      |> Matrix.from_string

    assert Matrix.transpose(m) == t
  end

  test "Transposing an identity matrix" do
    m = Matrix.ident(4)

    assert Matrix.transpose(m) == m
  end

  test "Calculating the determinant of a 2x2 matrix" do
    m =
      """
      |  1 | 5 |
      | -3 | 2 |
      """
      |> Matrix.from_string

    assert Matrix.det(m) == 17
  end

  test "A submatrix of a 4x4 matrix is a 3x3 matrix" do
    m =
      """
      | -6 |  1 |  1 |  6 |
      | -8 |  5 |  8 |  6 |
      | -1 |  0 |  8 |  2 |
      | -7 |  1 | -1 |  1 |
      """
      |> Matrix.from_string

    e =
      """
      | -6 |  1 | 6 |
      | -8 |  8 | 6 |
      | -7 | -1 | 1 |
      """
      |> Matrix.from_string

    assert Matrix.submatrix(m, 2, 1) == e
  end
end
