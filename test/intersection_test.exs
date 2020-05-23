defmodule IntersectionTest do
  alias RayTracer.RTuple
  alias RayTracer.Ray
  alias RayTracer.Sphere
  alias RayTracer.Shape
  alias RayTracer.Plane
  alias RayTracer.Intersection
  alias RayTracer.Transformations

  import RTuple, only: [point: 3, vector: 3]
  import Intersection, only: [prepare_computations: 2]
  import RayTracer.Constants

  use ExUnit.Case
  doctest RayTracer.Intersection

  test "Precomputing the state of an intersection" do
    r = Ray.new(point(0, 0, -5), vector(0, 0, 1))
    s = Sphere.new()

    i = Intersection.new(4, s)
    comps = prepare_computations(i, r)
    assert comps.t == i.t
    assert comps.point == point(0, 0, -1)
    assert comps.eyev == vector(0, 0, -1)
    assert comps.normalv == vector(0, 0, -1)
  end

  test "The hit, when an intersection occurs on the outside" do
    r = Ray.new(point(0, 0, -5), vector(0, 0, 1))
    s = Sphere.new()

    i = Intersection.new(4, s)
    comps = prepare_computations(i, r)
    assert comps.inside == false
  end

  test "The hit, when an intersection occurs on the inside" do
    r = Ray.new(point(0, 0, 0), vector(0, 0, 1))
    s = Sphere.new()

    i = Intersection.new(1, s)
    comps = prepare_computations(i, r)

    assert comps.t == i.t
    assert comps.point == point(0, 0, 1)
    assert comps.eyev == vector(0, 0, -1)
    # normal would have been (0, 0, 1), but is inverted!
    assert comps.normalv == vector(0, 0, -1)
    assert comps.inside == true
  end

  test "The hit should offset the point" do
    r = Ray.new(point(0, 0, -5), vector(0, 0, 1))
    s = Sphere.new |> Shape.set_transform(Transformations.translation(0, 0, 1))

    i = Intersection.new(5, s)
    comps = prepare_computations(i, r)

    opz = comps.over_point |> RTuple.z
    assert opz < epsilon() / 2
    assert comps.point |> RTuple.z > opz
  end

  test "Precomputing the reflection vector" do
    r = Ray.new(point(0, 1, -1), vector(0, -:math.sqrt(2) / 2, :math.sqrt(2) / 2))
    s = %Plane{}

    i = Intersection.new(:math.sqrt(2), s)
    comps = prepare_computations(i, r)

    assert comps.reflectv == vector(0, :math.sqrt(2) / 2, :math.sqrt(2) / 2)
  end
end
