defmodule TransformationsTest do
  alias RayTracer.Matrix
  alias RayTracer.RTuple
  import RayTracer.Transformations

  use ExUnit.Case
  doctest RayTracer.Transformations

  test "Multiplying by a translation matrix" do
    t = translation(5, -3, 2)
    p = RTuple.point(-3, 4, 5)

    assert t |> Matrix.mult(p) == RTuple.point(2, 1, 7)
  end

  test "Multiplying by the inverse of a translation matrix" do
    inv = translation(5, -3, 2) |> Matrix.inverse
    p = RTuple.point(-3, 4, 5)

    assert inv |> Matrix.mult(p) == RTuple.point(-8, 7, 3)
  end

  test "Translation does not affect vectors" do
    t = translation(5, -3, 2)
    v = RTuple.vector(-3, 4, 5)

    assert t |> Matrix.mult(v) == v
  end

  test "A scaling matrix applied to a vector" do
    t = scaling(2, 3, 4)
    p = RTuple.vector(-4, 6, 8)

    assert t |> Matrix.mult(p) == RTuple.vector(-8, 18, 32)
  end

  test "Multiplying by the inverse of a scaling matrix" do
    inv = scaling(2, 3, 4) |> Matrix.inverse
    v = RTuple.vector(-4, 6, 8)

    assert inv |> Matrix.mult(v) == RTuple.vector(-2, 2, 2)
  end

  test "Reflection is scaling by a negative value" do
    t = scaling(-1, 1, 1)
    v = RTuple.vector(2, 3, 4)

    assert t |> Matrix.mult(v) == RTuple.vector(-2, 3, 4)
  end
end
