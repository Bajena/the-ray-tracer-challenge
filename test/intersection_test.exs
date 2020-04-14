defmodule IntersectionTest do
  alias RayTracer.RTuple
  alias RayTracer.Ray
  alias RayTracer.Sphere
  alias RayTracer.Intersection

  import RTuple, only: [point: 3, vector: 3]
  import Intersection, only: [prepare_computations: 2]

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

# Scenario: The hit, when an intersection occurs on the inside
#   Given r ← ray(point(0, 0, 0), vector(0, 0, 1))
#     And shape ← sphere()
#     And i ← intersection(1, shape)
#   When comps ← prepare_computations(i, r)
#   Then comps.point = point(0, 0, 1)
#     And comps.eyev = vector(0, 0, -1)
#     And comps.inside = true
#       # normal would have been (0, 0, 1), but is inverted!
#     And comps.normalv = vector(0, 0, -1)

# Scenario: The hit, when an intersection occurs on the outside
#   Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
#     And shape ← sphere()
#     And i ← intersection(4, shape)
#   When comps ← prepare_computations(i, r)
#   Then comps.inside = false

  # Scenario: Precomputing the state of an intersection
  #   Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
  #     And shape ← sphere()
  #     And i ← intersection(4, shape)
  #   When comps ← prepare_computations(i, r)
  #   Then comps.t = i.t
  #     And comps.object = i.object
  #     And comps.point = point(0, 0, -1)
  #     And comps.eyev = vector(0, 0, -1)
  #     And comps.normalv = vector(0, 0, -1)
end
