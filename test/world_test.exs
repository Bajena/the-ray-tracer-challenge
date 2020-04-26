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

  import RayTracer.RTuple.CustomOperators
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

  test "Shading an intersection" do
    w = World.default()
    r = Ray.new(point(0, 0, -5), vector(0, 0, 1))
    s = Enum.at(w.objects, 0)
    i = Intersection.new(4, s)
    comps = Intersection.prepare_computations(i, r)

    c = w |> World.shade_hit(comps)

    assert c <~> Color.new(0.38066, 0.47583, 0.2855)
  end

  test "The color when a ray misses" do
    w = World.default()
    r = Ray.new(point(0, 0, -5), vector(0, 1, 0))
    c = w |> World.color_at(r)

    assert c <~> Color.new(0, 0, 0)
  end

  test "The color when a ray hits" do
    w = World.default()
    r = Ray.new(point(0, 0, -5), vector(0, 0, 1))
    c = w |> World.color_at(r)

    assert c <~> Color.new(0.38066, 0.47583, 0.2855)
  end

  test "The color with an intersection behind the ray" do
    dw = World.default()
    douter = Enum.at(dw.objects, 0)
    dinner = Enum.at(dw.objects, 1)

    w = %World{
      dw | objects: [
        %Sphere{douter | material: %Material{douter.material | ambient: 1}},
        %Sphere{dinner | material: %Material{dinner.material | ambient: 1}}
      ]
    }
    inner = Enum.at(w.objects, 1)

    r = Ray.new(point(0, 0, 0.75), vector(0, 0, -1))
    c = w |> World.color_at(r)
    assert c <~> inner.material.color
  end

  test "There is no shadow when nothing is collinear with point and light" do
    w = World.default()
    p = point(0, 10, 0)

    assert w |> World.is_shadowed(p) == false
  end

  test "The shadow when an object is between the point and the light" do
    w = World.default()
    p = point(10, -10, 10)

    assert w |> World.is_shadowed(p) == true
  end

  test "There is no shadow when an object is behind the light" do
    w = World.default()
    p = point(-20, 20, -20)

    assert w |> World.is_shadowed(p) == false
  end

  test "There is no shadow when an object is behind the point" do
    w = World.default()
    p = point(-2, 2, -2)

    assert w |> World.is_shadowed(p) == false
  end

  test "shade_hit() is given an intersection in shadow" do
    light = Light.point_light(point(0, 0, -10), Color.new(1, 1, 1))
    s1 = Sphere.new
    s2 = Sphere.new |> Sphere.set_transform(Transformations.translation(0, 0, 10))
    w = World.new([s1, s2], light)

    r = Ray.new(point(0, 0, 5), vector(0, 0, 1))
    i = Intersection.new(4, s2)
    comps = i |> Intersection.prepare_computations(r)
    c = w |> World.shade_hit(comps)

    assert c <~> Color.new(0.1, 0.1, 0.1)
  end
end
