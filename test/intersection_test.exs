defmodule IntersectionTest do
  alias RayTracer.RTuple
  alias RayTracer.Ray
  alias RayTracer.Sphere
  alias RayTracer.Shape
  alias RayTracer.Plane
  alias RayTracer.Intersection
  alias RayTracer.Transformations

  import RTuple, only: [point: 3, vector: 3]
  import Intersection, only: [prepare_computations: 2, prepare_computations: 3, intersections: 1]
  import RayTracer.Constants
  import Transformations, only: [scaling: 3, translation: 3]

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

  combinations = [
    {0, 1.0, 1.5},
    {1, 1.5, 2.0},
    {2, 2.0, 2.5},
    {3, 2.5, 2.5},
    {4, 2.5, 1.5},
    {5, 1.5, 1.0}
  ]

  for {index, n1, n2} <- combinations do
    test "Finding n1 and n2 at various intersections (#{index}, #{n1}, #{n2})" do
      index = unquote(index)
      n1 = unquote(n1)
      n2 = unquote(n2)

      a =
        put_in(Sphere.glass_sphere().material.refractive_index, 1.5)
        |> Shape.set_transform(scaling(2, 2, 2))

      b =
        put_in(Sphere.glass_sphere().material.refractive_index, 2.0)
        |> Shape.set_transform(translation(0, 0, -0.25))

      c =
        put_in(Sphere.glass_sphere().material.refractive_index, 2.5)
        |> Shape.set_transform(translation(0, 0, 0.25))

      r = Ray.new(point(0, 0, -4), vector(0, 0, 1))
      xs = intersections([
        {2, a},
        {2.75, b},
        {3.25, c},
        {4.75, b},
        {5.25, c},
        {6, a}
      ])

      i = Enum.at(xs, index)
      comps = prepare_computations(i, r, xs)

      assert comps.n1 == n1
      assert comps.n2 == n2
    end
  end

  test "The under point is offset below the surface" do
    r = Ray.new(point(0, 0, -5), vector(0, 0, 1))
    s = Sphere.glass_sphere() |> Shape.set_transform(Transformations.translation(0, 0, 1))

    i = Intersection.new(5, s)
    comps = prepare_computations(i, r)

    upz = comps.under_point |> RTuple.z
    assert upz > epsilon() / 2
    assert comps.point |> RTuple.z < upz
  end
end
