defmodule RTupleTest do
  alias RayTracer.RTuple

  import RTuple, only: [point: 3, vector: 3, reflect: 2, point?: 1, vector?: 1]
  import RTuple.CustomOperators

  use ExUnit.Case
  doctest RayTracer.RTuple

  test "a tuple with w = 1.0 is a point" do
    res = {4.3, -4.2, 3.1, 1.0} |> RTuple.new |> point?

    assert(res)
  end

  test "a tuple with w = 0.0 is not a point" do
    res = {4.3, -4.2, 3.1, 0.0} |> RTuple.new |> point?

    assert(!res)
  end

  test "a tuple with w = 1.0 is not a vector" do
    res = {4.3, -4.2, 3.1, 1.0} |> RTuple.new |> vector?

    assert(!res)
  end

  test "a tuple with w = 0.0 is a vector" do
    res = {4.3, -4.2, 3.1, 0.0} |> RTuple.new |> vector?

    assert(res)
  end

  test "point() creates tuples with w = 1.0" do
    assert point(4, -4, 3) |> RTuple.w == 1.0
  end

  test "vector() creates tuples with w = 0.0" do
    assert vector(4, -4, 3) |> RTuple.w == 0.0
  end

  test "subtracting two points" do
    t1 = point(1, 2, 3.5)
    t2 = point(3, 2, 1.2)

    assert RTuple.sub(t1, t2) == vector(-2,  0, 2.3)
  end

  test "subtracting a vector from a point" do
    t1 = point(1, 2, 3.5)
    t2 = vector(3, 2, 1.2)

    assert RTuple.sub(t1, t2) == point(-2,  0, 2.3)
  end

  test "subtracting two vectors" do
    t1 = vector(1, 2, 3.5)
    t2 = vector(3, 2, 1.2)

    assert RTuple.sub(t1, t2) == vector(-2,  0, 2.3)
  end

  test "adding two tuples" do
    t1 = point(1, 2, 3.5)
    t2 = vector(3, 2, 1.2)

    assert RTuple.add(t1, t2) == point(4, 4, 4.7)
  end

  test "negating a tuple" do
    t = RTuple.new({1, 2, 3, 1})

    assert RTuple.negate(t) == RTuple.new({-1, -2, -3, -1})
  end

  test "multiplying a tuple by a scalar" do
    t = RTuple.new({1, 2, 3, 1})
    e = RTuple.new({0.5, 1, 1.5, 0.5})

    assert RTuple.mul(t, 0.5) == e
    assert RTuple.mul(0.5, t) == e
  end

  test "dividing a tuple by a scalar" do
    t = RTuple.new({1, 2, 3, 1})
    e = RTuple.new({0.5, 1, 1.5, 0.5})

    assert RTuple.div(t, 2) == e
  end

  test "magnitude (length) of a vector" do
    assert vector(1, 0, 0) |> RTuple.magnitude == 1
    assert vector(0, 1, 0) |> RTuple.magnitude == 1
    assert vector(0, 0, 1) |> RTuple.magnitude == 1
    assert vector(-1, -2, -3) |> RTuple.length == :math.sqrt(14)
    assert vector(1, 2, 3) |> RTuple.length == :math.sqrt(14)
  end

  test "normalization of a vector" do
    s = :math.sqrt(14)
    assert vector(4, 0, 0) |> RTuple.normalize == vector(1, 0, 0)

    n = vector(1, 2, 3) |> RTuple.normalize
    assert n == vector(1 / s, 2 / s, 3 / s)

    assert n |> RTuple.magnitude == 1
  end

  test "dot product of two vectors" do
    v1 = vector(1, 2, 3)
    v2 = vector(2, 3, 4)
    assert RTuple.dot(v1, v2) == 20
  end

  test "cross product of two vectors" do
    v1 = vector(1, 2, 3)
    v2 = vector(2, 3, 4)

    assert RTuple.cross(v1, v2) == vector(-1, 2, -1)
    assert RTuple.cross(v2, v1) == vector(1, -2, 1)
  end

  test "Reflecting a vector approaching at 45°" do
    v = vector(1, -1, 0)
    n = vector(0, 1, 0)

    assert reflect(v, n) == vector(1, 1, 0)
  end

  test "Reflecting a vector off a slanted surface" do
    v = vector(0, -1, 0)
    n = vector(:math.sqrt(2) / 2, :math.sqrt(2) / 2, 0)

    assert reflect(v, n) <~> vector(1, 0, 0)
  end
end
