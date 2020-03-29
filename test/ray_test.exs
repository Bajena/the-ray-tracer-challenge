defmodule RayTest do
  alias RayTracer.RTuple
  alias RayTracer.Ray
  import RTuple, only: [point: 3, vector: 3]
  import RayTracer.Transformations, only: [translation: 3, scaling: 3]
  import Ray

  use ExUnit.Case
  doctest RayTracer.Ray

  test "Creating and querying a ray" do
    origin = point(1, 2, 3)
    direction = vector(4, 5, 6)
    r = Ray.new(origin, direction)

    assert r.origin == origin
    assert r.direction == direction
  end

  test "Computing a point from a distance" do
    r = Ray.new(point(2, 3, 4), vector(1, 0, 0))

    assert position(r, 0) == point(2, 3, 4)
    assert position(r, 1) == point(3, 3, 4)
    assert position(r, -1) == point(1, 3, 4)
  end

  test "Translating a ray" do
    r = Ray.new(point(1, 2, 3), vector(0, 1, 0))
    m = translation(3, 4, 5)

    assert transform(r, m) == Ray.new(point(4, 6, 8), vector(0, 1, 0))
  end

  test "Scaling a ray" do
    r = Ray.new(point(1, 2, 3), vector(0, 1, 0))
    m = scaling(2, 3, 4)

    assert transform(r, m) == Ray.new(point(2, 6, 12), vector(0, 3, 0))
  end
end
