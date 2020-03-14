defmodule RTupleTest do
  alias RayTracer.RTuple
  use ExUnit.Case
  doctest RayTracer.RTuple

  test "a tuple with w = 1.0 is a point" do
    res = { 4.3, -4.2, 3.1, 1.0 } |> RTuple.new |> RTuple.point?

    assert(res)
  end

  test "a tuple with w = 0.0 is not a point" do
    res = { 4.3, -4.2, 3.1, 0.0 } |> RTuple.new |> RTuple.point?

    assert(!res)
  end

  test "a tuple with w = 1.0 is not a vector" do
    res = { 4.3, -4.2, 3.1, 1.0 } |> RTuple.new |> RTuple.vector?

    assert(!res)
  end

  test "a tuple with w = 0.0 is a vector" do
    res = { 4.3, -4.2, 3.1, 0.0 } |> RTuple.new |> RTuple.vector?

    assert(res)
  end

  test "point() creates tuples with w = 1.0" do
    assert RTuple.point(4, -4, 3) |> RTuple.w == 1.0
  end

  test "vector() creates tuples with w = 0.0" do
    assert RTuple.vector(4, -4, 3) |> RTuple.w == 0.0
  end
end
