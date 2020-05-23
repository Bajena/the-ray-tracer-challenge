defmodule SphereTest do
  alias RayTracer.RTuple
  alias RayTracer.Matrix
  alias RayTracer.Ray
  alias RayTracer.Sphere
  alias RayTracer.Shape
  alias RayTracer.Intersection
  import RTuple, only: [point: 3, vector: 3]
  import Intersection, only: [intersect: 2, hit: 1]
  import RayTracer.Transformations
  import RayTracer.RTuple.CustomOperators

  use ExUnit.Case
  doctest RayTracer.Sphere

  test "A helper for producing a sphere with a glassy material" do
    s = Sphere.glass_sphere()
    assert s.material.transparency == 1.0
    assert s.material.refractive_index == 1.5
  end

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

    assert s.transform == Matrix.ident
  end

  test "Changing a sphere's transformation" do
    s = Sphere.new()
    t = translation(2, 3, 4)
    assert Shape.set_transform(s, t).transform == t
  end

  test "Intersecting a scaled sphere with a ray" do
    r = Ray.new(point(0, 0, -5), vector(0, 0, 1))
    s = Sphere.new() |> Shape.set_transform(scaling(2, 2, 2))
    xs = intersect(s, r)

    assert length(xs) == 2
    assert Enum.at(xs, 0).t == 3
    assert Enum.at(xs, 1).t == 7
  end

  test "Intersecting a translated sphere with a ray" do
    r = Ray.new(point(0, 0, -5), vector(0, 0, 1))
    s = Sphere.new() |> Shape.set_transform(translation(5, 0, 0))
    xs = intersect(s, r)

    assert Enum.empty?(xs)
  end

  test "The normal on a sphere at a point on the x axis" do
    assert Sphere.new() |> Sphere.normal_at(point(1, 0, 0)) == vector(1, 0, 0)
  end

  test "The normal on a sphere at a point on the y axis" do
    assert Sphere.new() |> Sphere.normal_at(point(0, 1, 0)) == vector(0, 1, 0)
  end

  test "The normal on a sphere at a point on the z axis" do
    assert Sphere.new() |> Sphere.normal_at(point(0, 0, 1)) == vector(0, 0, 1)
  end

  test "The normal on a sphere at a nonaxial point" do
    v = :math.sqrt(3) / 3
    assert Sphere.new() |> Sphere.normal_at(point(v, v, v)) == vector(v, v, v)
  end

  test "The normal is a normalized vector" do
    v = :math.sqrt(3) / 3
    n = Sphere.new() |> Sphere.normal_at(point(v, v, v))

    assert n == n |> RTuple.normalize
  end

  test "Computing the normal on a translated sphere" do
    s = Sphere.new() |> Shape.set_transform(translation(0, 1, 0))
    n = s |> Sphere.normal_at(point(0, 1.70711, -0.70711))

    assert n <~> vector(0, 0.70711, -0.70711)
  end

  test "Computing the normal on a transformed sphere" do
    t = scaling(1, 0.5, 1) |> Matrix.mult(rotation_z(:math.pi / 5))
    s = Sphere.new() |> Shape.set_transform(t)
    n = s |> Sphere.normal_at(point(0, :math.sqrt(2) / 2, -:math.sqrt(2) / 2))

    assert n <~> vector(0, 0.97014, -0.24254)
  end
end
