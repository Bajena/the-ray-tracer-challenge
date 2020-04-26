defmodule MaterialTest do
  alias RayTracer.Color
  alias RayTracer.Material
  alias RayTracer.RTuple
  alias RayTracer.Light

  import RTuple, only: [point: 3, vector: 3]
  import Light, only: [point_light: 2, lighting: 6]
  import RTuple.CustomOperators

  use ExUnit.Case
  doctest RayTracer.Material

  test "The default material" do
    m = Material.new

    assert m.color == Color.new(1, 1, 1)
    assert m.ambient == 0.1
    assert m.diffuse == 0.9
    assert m.specular == 0.9
    assert m.shininess == 200.0
  end

  test "Lighting with the eye between the light and the surface" do
    m = Material.new
    position = point(0, 0, 0)
    eyev = vector(0, 0, -1)
    normalv = vector(0, 0, -1)
    light = point_light(point(0, 0, -10), Color.new(1, 1, 1))

    assert lighting(m, light, position, eyev, normalv, false) == Color.new(1.9, 1.9, 1.9)
  end

  test "Lighting with the eye between light and surface, eye offset 45°" do
    m = Material.new
    position = point(0, 0, 0)
    sq2d2 = :math.sqrt(2) / 2

    eyev = vector(0, sq2d2, -sq2d2)
    normalv = vector(0, 0, -1)
    light = point_light(point(0, 0, -10), Color.new(1, 1, 1))

    assert lighting(m, light, position, eyev, normalv, false) == Color.new(1, 1, 1)
  end

  test "Lighting with eye opposite surface, light offset 45°" do
    m = Material.new
    position = point(0, 0, 0)

    eyev = vector(0, 0, -1)
    normalv = vector(0, 0, -1)
    light = point_light(point(0, 10, -10), Color.new(1, 1, 1))

    assert lighting(m, light, position, eyev, normalv, false) <~> Color.new(0.7364, 0.7364, 0.7364)
  end

  test "Lighting with eye in the path of the reflection vector" do
    m = Material.new
    position = point(0, 0, 0)

    sq2d2 = :math.sqrt(2) / 2
    eyev = vector(0, -sq2d2, -sq2d2)
    normalv = vector(0, 0, -1)
    light = point_light(point(0, 10, -10), Color.new(1, 1, 1))

    assert lighting(m, light, position, eyev, normalv, false) <~> Color.new(1.6364, 1.6364, 1.6364)
  end

  test "Lighting with the light behind the surface" do
    m = Material.new
    position = point(0, 0, 0)

    eyev = vector(0, 0, -1)
    normalv = vector(0, 0, -1)
    light = point_light(point(0, 0, 10), Color.new(1, 1, 1))

    assert lighting(m, light, position, eyev, normalv, false) <~> Color.new(0.1, 0.1, 0.1)
  end

  test "Lighting with the surface in shadow" do
    m = Material.new
    position = point(0, 0, 0)

    eyev = vector(0, 0, -1)
    normalv = vector(0, 0, -1)
    light = point_light(point(0, 0, -10), Color.new(1, 1, 1))
    in_shadow = true

    assert lighting(m, light, position, eyev, normalv, in_shadow) <~> Color.new(0.1, 0.1, 0.1)
  end
end
