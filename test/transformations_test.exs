defmodule TransformationsTest do
  alias RayTracer.Matrix
  alias RayTracer.RTuple
  import RayTracer.Transformations
  import RTuple.CustomOperators
  import RTuple, only: [point: 3, vector: 3]
  import Matrix, only: [mult: 2, inverse: 1]

  use ExUnit.Case
  doctest RayTracer.Transformations

  test "Multiplying by a translation matrix" do
    t = translation(5, -3, 2)
    p = point(-3, 4, 5)

    assert t |> mult(p) == point(2, 1, 7)
  end

  test "Multiplying by the inverse of a translation matrix" do
    inv = translation(5, -3, 2) |> inverse
    p = point(-3, 4, 5)

    assert inv |> mult(p) == point(-8, 7, 3)
  end

  test "Translation does not affect vectors" do
    t = translation(5, -3, 2)
    v = vector(-3, 4, 5)

    assert t |> mult(v) == v
  end

  test "A scaling matrix applied to a vector" do
    t = scaling(2, 3, 4)
    p = vector(-4, 6, 8)

    assert t |> mult(p) == vector(-8, 18, 32)
  end

  test "Multiplying by the inverse of a scaling matrix" do
    inv = scaling(2, 3, 4) |> inverse
    v = vector(-4, 6, 8)

    assert inv |> mult(v) == vector(-2, 2, 2)
  end

  test "Reflection is scaling by a negative value" do
    t = scaling(-1, 1, 1)
    v = vector(2, 3, 4)

    assert t |> mult(v) == vector(-2, 3, 4)
  end

  test "Rotating a point around the x axis" do
    p = point(0, 1, 0)
    half_quarter = rotation_x(:math.pi / 4)
    full_quarter = rotation_x(:math.pi / 2)

    assert half_quarter |> mult(p) <~> point(0, :math.sqrt(2) / 2, :math.sqrt(2) / 2)
    assert full_quarter |> mult(p) <~> point(0, 0, 1)
  end

  test "The inverse of an x-rotation rotates in the opposite direction" do
    p = point(0, 1, 0)
    half_quarter = rotation_x(:math.pi / 4)
    inv = inverse(half_quarter)

    assert inv |> mult(p) <~> point(0, :math.sqrt(2) / 2, -:math.sqrt(2) / 2)
  end

  test "Rotating a point around the y axis" do
    p = point(0, 0, 1)
    half_quarter = rotation_y(:math.pi / 4)
    full_quarter = rotation_y(:math.pi / 2)

    assert half_quarter |> mult(p) <~> point(:math.sqrt(2) / 2, 0, :math.sqrt(2) / 2)
    assert full_quarter |> mult(p) <~> point(1, 0, 0)
  end

  test "Rotating a point around the z axis" do
    p = point(0, 1, 0)
    half_quarter = rotation_z(:math.pi / 4)
    full_quarter = rotation_z(:math.pi / 2)

    assert half_quarter |> mult(p) <~> point(-:math.sqrt(2) / 2, :math.sqrt(2) / 2, 0)
    assert full_quarter |> mult(p) <~> point(-1, 0, 0)
  end

  test "A shearing transformation moves x in proportion to y" do
    t = shearing(1, 0, 0, 0, 0, 0)
    p = point(2, 3, 4)

    assert t |> mult(p) <~> point(5, 3, 4)
  end

  test "A shearing transformation moves x in proportion to z" do
    t = shearing(0, 1, 0, 0, 0, 0)
    p = point(2, 3, 4)

    assert t |> mult(p) <~> point(6, 3, 4)
  end

  test "A shearing transformation moves y in proportion to x" do
    t = shearing(0, 0, 1, 0, 0, 0)
    p = point(2, 3, 4)

    assert t |> mult(p) <~> point(2, 5, 4)
  end

  test "A shearing transformation moves y in proportion to z" do
    t = shearing(0, 0, 0, 1, 0, 0)
    p = point(2, 3, 4)

    assert t |> mult(p) <~> point(2, 7, 4)
  end

  test "A shearing transformation moves z in proportion to x" do
    t = shearing(0, 0, 0, 0, 1, 0)
    p = point(2, 3, 4)

    assert t |> mult(p) <~> point(2, 3, 6)
  end

  test "A shearing transformation moves z in proportion to y" do
    t = shearing(0, 0, 0, 0, 0, 1)
    p = point(2, 3, 4)

    assert t |> mult(p) <~> point(2, 3, 7)
  end

  test "Individual transformations are applied in sequence" do
    p = point(1, 0, 1)
    a = rotation_x(:math.pi / 2)
    b = scaling(5, 5, 5)
    c = translation(10, 5, 7)

    # apply rotation first
    p2 = a |> mult(p)
    assert p2 <~> point(1, -1, 0)

    # then apply scaling
    p3 = b |> mult(p2)
    assert p3 <~> point(5, -5, 0)

    # then apply translation
    p4 = c |> mult(p3)
    assert p4 <~> point(15, 0, 7)
  end

  test "Chained transformations must be applied in reverse order" do
    p = point(1, 0, 1)
    a = rotation_x(:math.pi / 2)
    b = scaling(5, 5, 5)
    c = translation(10, 5, 7)

    r =
      c
      |> mult(b)
      |> mult(a)
      |> mult(p)

    assert r <~> point(15, 0, 7)
  end
end
