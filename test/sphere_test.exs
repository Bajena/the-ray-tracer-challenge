defmodule SphereTest do
  alias RayTracer.RTuple
  alias RayTracer.Matrix
  alias RayTracer.Ray
  alias RayTracer.Sphere
  alias RayTracer.Intersection
  import RTuple, only: [point: 3, vector: 3]
  import Intersection, only: [intersect: 2, hit: 1]
  import RayTracer.Transformations

  use ExUnit.Case
  doctest RayTracer.Sphere

  test "A ray intersects a sphere at two points" do
    r = Ray.new(point(0, 0, -5), vector(0, 0, 1))
    s = Sphere.new()

    xs = intersect(s, r)
    assert length(xs) == 2
    assert Enum.at(xs, 0).t == 4
    assert Enum.at(xs, 1).t == 6
  end

  test "A ray intersects a sphere at a tangent" do
    r = Ray.new(point(0, 1, -5), vector(0, 0, 1))
    s = Sphere.new()

    xs = intersect(s, r)
    assert length(xs) == 2
    assert Enum.at(xs, 0).t == 5
    assert Enum.at(xs, 1).t == 5
  end

  test "A ray misses a sphere" do
    r = Ray.new(point(0, 2, -5), vector(0, 0, 1))
    s = Sphere.new()

    xs = intersect(s, r)
    assert Enum.empty?(xs)
  end

  test "A ray originates inside a sphere" do
    r = Ray.new(point(0, 0, 0), vector(0, 0, 1))
    s = Sphere.new()

    xs = intersect(s, r)
    assert length(xs) == 2
    assert Enum.at(xs, 0).t == -1
    assert Enum.at(xs, 1).t == 1
  end

  test "A sphere is behind a ray" do
    r = Ray.new(point(0, 0, 5), vector(0, 0, 1))
    s = Sphere.new()

    xs = intersect(s, r)
    assert length(xs) == 2
    assert Enum.at(xs, 0).t == -6
    assert Enum.at(xs, 1).t == -4
  end

  test "Intersect sets the object on the intersection" do
    r = Ray.new(point(0, 0, -5), vector(0, 0, 1))
    s = Sphere.new()

    xs = intersect(s, r)
    assert length(xs) == 2
    assert Enum.at(xs, 0).object == s
    assert Enum.at(xs, 1).object == s
  end

  test "The hit, when all intersections have positive t" do
    s = Sphere.new()
    i1 = Intersection.new(1, s)
    i2 = Intersection.new(2, s)
    xs = [i2, i1]

    assert hit(xs) == i1
  end

  test "The hit, when some intersections have negative t" do
    s = Sphere.new()
    i1 = Intersection.new(-1, s)
    i2 = Intersection.new(1, s)
    xs = [i2, i1]

    assert hit(xs) == i2
  end

  test "The hit, when all intersections have negative t" do
    s = Sphere.new()
    i1 = Intersection.new(-2, s)
    i2 = Intersection.new(-1, s)
    xs = [i2, i1]

    assert hit(xs) == nil
  end

  test "The hit is always the lowest nonnegative intersection" do
    s = Sphere.new()
    i1 = Intersection.new(5, s)
    i2 = Intersection.new(7, s)
    i3 = Intersection.new(-3, s)
    i4 = Intersection.new(2, s)
    xs = [i1, i2, i3, i4]

    assert hit(xs) == i4
  end

  test "A sphere's default transformation" do
    s = Sphere.new()

    assert s.transform == Matrix.ident(4)
  end

  test "Changing a sphere's transformation" do
    s = Sphere.new()
    t = translation(2, 3, 4)
    assert Sphere.set_transform(s, t).transform == t
  end

  test "Intersecting a scaled sphere with a ray" do
    r = Ray.new(point(0, 0, -5), vector(0, 0, 1))
    s = Sphere.new() |> Sphere.set_transform(scaling(2, 2, 2))
    xs = intersect(s, r)

    assert length(xs) == 2
    assert Enum.at(xs, 0).t == 3
    assert Enum.at(xs, 1).t == 7
  end

  test "Intersecting a translated sphere with a ray" do
    r = Ray.new(point(0, 0, -5), vector(0, 0, 1))
    s = Sphere.new() |> Sphere.set_transform(translation(5, 0, 0))
    xs = intersect(s, r)

    assert length(xs) == 0
  end
end
