defmodule MaterialTest do
  alias RayTracer.Color
  alias RayTracer.Material
  alias RayTracer.RTuple
  alias RayTracer.Light
  alias RayTracer.StripePattern
  alias RayTracer.Sphere

  import RTuple, only: [point: 3, vector: 3]
  import Light, only: [point_light: 2, lighting: 7]
  import RTuple.CustomOperators

  use ExUnit.Case
  doctest RayTracer.Material

  setup do
    [default_object: Sphere.new]
  end

  test "The default material" do
    m = Material.new

    assert m.color == Color.new(1, 1, 1)
    assert m.ambient == 0.1
    assert m.diffuse == 0.9
    assert m.specular == 0.9
    assert m.shininess == 200.0
    assert m.transparency == 0.0
    assert m.refractive_index == 1.0
  end

  test "Lighting with the eye between the light and the surface", context do
    m = Material.new
    position = point(0, 0, 0)
    eyev = vector(0, 0, -1)
    normalv = vector(0, 0, -1)
    light = point_light(point(0, 0, -10), Color.new(1, 1, 1))

    assert lighting(m, context.default_object, light, position, eyev, normalv, false) == Color.new(1.9, 1.9, 1.9)
  end

  test "Lighting with the eye between light and surface, eye offset 45°", context do
    m = Material.new
    position = point(0, 0, 0)
    sq2d2 = :math.sqrt(2) / 2

    eyev = vector(0, sq2d2, -sq2d2)
    normalv = vector(0, 0, -1)
    light = point_light(point(0, 0, -10), Color.new(1, 1, 1))

    assert lighting(m, context.default_object, light, position, eyev, normalv, false) == Color.new(1, 1, 1)
  end

  test "Lighting with eye opposite surface, light offset 45°", context do
    m = Material.new
    position = point(0, 0, 0)

    eyev = vector(0, 0, -1)
    normalv = vector(0, 0, -1)
    light = point_light(point(0, 10, -10), Color.new(1, 1, 1))

    assert lighting(m, context.default_object, light, position, eyev, normalv, false) <~> Color.new(0.7364, 0.7364, 0.7364)
  end

  test "Lighting with eye in the path of the reflection vector", context do
    m = Material.new
    position = point(0, 0, 0)

    sq2d2 = :math.sqrt(2) / 2
    eyev = vector(0, -sq2d2, -sq2d2)
    normalv = vector(0, 0, -1)
    light = point_light(point(0, 10, -10), Color.new(1, 1, 1))

    assert lighting(m, context.default_object, light, position, eyev, normalv, false) <~> Color.new(1.6364, 1.6364, 1.6364)
  end

  test "Lighting with the light behind the surface", context do
    m = Material.new
    position = point(0, 0, 0)

    eyev = vector(0, 0, -1)
    normalv = vector(0, 0, -1)
    light = point_light(point(0, 0, 10), Color.new(1, 1, 1))

    assert lighting(m, context.default_object, light, position, eyev, normalv, false) <~> Color.new(0.1, 0.1, 0.1)
  end

  test "Lighting with the surface in shadow", context do
    m = Material.new
    position = point(0, 0, 0)

    eyev = vector(0, 0, -1)
    normalv = vector(0, 0, -1)
    light = point_light(point(0, 0, -10), Color.new(1, 1, 1))
    in_shadow = true

    assert lighting(m, context.default_object, light, position, eyev, normalv, in_shadow) <~> Color.new(0.1, 0.1, 0.1)
  end

  test "Lighting with a pattern applied", context do
    pattern = StripePattern.new(Color.white, Color.black)
    m = %Material{ambient: 1, diffuse: 0, specular: 0, pattern: pattern}

    eyev = vector(0, 0, -1)
    normalv = vector(0, 0, -1)
    light = point_light(point(0, 0, -10), Color.new(1, 1, 1))
    in_shadow = false

    assert lighting(m, context.default_object, light, point(0.9, 0, 0), eyev, normalv, in_shadow) <~> Color.white
    assert lighting(m, context.default_object, light, point(1.1, 0, 0), eyev, normalv, in_shadow) <~> Color.black
  end
end
