defmodule RayTest do
  alias RayTracer.RTuple
  alias RayTracer.Ray
  import RTuple, only: [point: 3, vector: 3]

  use ExUnit.Case
  doctest RayTracer.Ray

  # Scenario: Creating and querying a ray
  #   Given origin ← point(1, 2, 3)
  #     And direction ← vector(4, 5, 6)
  #   When r ← ray(origin, direction)
  #   Then r.origin = origin
  #     And r.direction = direction

  test "Creating and querying a ray" do
    origin = point(1, 2, 3)
    direction = vector(4, 5, 6)
    r = Ray.new(origin, direction)

    assert r.origin == origin
    assert r.direction == direction
  end
end
