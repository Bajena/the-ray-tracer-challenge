defmodule WorldTest do
  alias RayTracer.World
  alias RayTracer.Material
  alias RayTracer.Transformations
  alias RayTracer.RTuple
  alias RayTracer.Color
  alias RayTracer.Sphere
  alias RayTracer.Ray
  alias RayTracer.Light
  alias RayTracer.Intersection

  import RTuple, only: [point: 3, vector: 3]

  use ExUnit.Case
  doctest RayTracer.World

  test "Creating a world" do
    w = World.new()

    assert w.objects == []
    assert w.light == nil
  end

  test "The default world" do
    material = %Material{Material.new | color: Color.new(0.8, 1.0, 0.6), diffuse: 0.7, specular: 0.2}
    s1 = %Sphere{Sphere.new | material: material}

    s2 = %Sphere{Sphere.new | transform: Transformations.scaling(0.5, 0.5, 0.5)}

    light = Light.point_light(RTuple.point(-10, 10, -10), Color.white)
    w = World.default()

    assert w.objects == [s1, s2]
    assert w.light == light
  end

  test "Intersect a world with a ray" do
    w = World.default()
    r = Ray.new(point(0, 0, -5), vector(0, 0, 1))
    xs = Intersection.intersect_world(w, r)

    assert length(xs) == 4
    assert Enum.at(xs, 0).t == 4
    assert Enum.at(xs, 1).t == 4.5
    assert Enum.at(xs, 2).t == 5.5
    assert Enum.at(xs, 3).t == 6
  end
end
