defmodule SphereTest do
  alias RayTracer.RTuple
  alias RayTracer.Ray
  alias RayTracer.Sphere
  import RTuple, only: [point: 3, vector: 3]
  import RayTracer.Intersection, only: [intersect: 2]

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
    assert length(xs) == 0
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
end
