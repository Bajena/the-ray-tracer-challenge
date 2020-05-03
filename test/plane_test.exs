defmodule PlaneTest do
  alias RayTracer.RTuple
  alias RayTracer.Matrix
  alias RayTracer.Ray
  alias RayTracer.Plane
  alias RayTracer.Shape
  alias RayTracer.Intersection
  import RTuple, only: [point: 3, vector: 3]
  import Intersection, only: [intersect: 2, hit: 1]
  import RayTracer.Transformations
  import RayTracer.RTuple.CustomOperators

  use ExUnit.Case
  doctest RayTracer.Plane

  test "The normal of a plane is constant everywhere" do
    p = Plane.new()
    n1 = p |> Shape.local_normal_at(point(0, 0, 0))
    n2 = p |> Shape.local_normal_at(point(10, 0, -10))
    n3 = p |> Shape.local_normal_at(point(-5, 0, 150))

    expected = vector(0, 1, 0)
    assert n1 == expected
    assert n2 == expected
    assert n3 == expected
  end

  test "Intersect with a ray parallel to the Plane" do
    p = Plane.new()
    r = Ray.new(point(0, 10, 0), vector(0, 0, 1))

    xs = p |> Shape.local_intersect(r)
    assert Enum.empty?(xs)
  end

  test "Intersect with a coplanar ray" do
    p = Plane.new()
    r = Ray.new(point(0, 0, 0), vector(0, 0, 1))

    xs = p |> Shape.local_intersect(r)
    assert Enum.empty?(xs)
  end

  test "A ray intersecting a plane from above" do
    p = Plane.new()
    r = Ray.new(point(0, 1, 0), vector(0, -1, 0))

    xs = p |> Shape.local_intersect(r)
    assert length(xs) == 1
    assert Enum.at(xs, 0).t == 1
    assert Enum.at(xs, 0).object == p
  end

  test "A ray intersecting a plane from below" do
    p = Plane.new()
    r = Ray.new(point(0, -1, 0), vector(0, 1, 0))

    xs = p |> Shape.local_intersect(r)
    assert length(xs) == 1
    assert Enum.at(xs, 0).t == 1
    assert Enum.at(xs, 0).object == p
  end
end
