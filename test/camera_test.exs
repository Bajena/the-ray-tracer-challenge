defmodule CameraTest do
  alias RayTracer.Camera
  alias RayTracer.Matrix

  use ExUnit.Case
  doctest RayTracer.Camera

  test "Constructing a camera" do
    c = Camera.new(160, 120, :math.pi / 2)

    assert c.hsize == 160
    assert c.vsize == 120
    assert c.field_of_view == :math.pi / 2
    assert c.transform == Matrix.ident
  end

  test "The pixel size for a horizontal canvas" do
    c = Camera.new(200, 125, :math.pi / 2)

    assert c.pixel_size |> Float.round(5) == 0.01
  end

  test "The pixel size for a vertical canvas" do
    c = Camera.new(200, 125, :math.pi / 2)

    assert c.pixel_size |> Float.round(5) == 0.01
  end

# Scenario: The pixel size for a vertical canvas
#   Given c ← camera(125, 200, π/2)
#   Then c.pixel_size = 0.01

# Scenario: Constructing a ray through the center of the canvas
#   Given c ← camera(201, 101, π/2)
#   When r ← ray_for_pixel(c, 100, 50)
#   Then r.origin = point(0, 0, 0)
#     And r.direction = vector(0, 0, -1)

# Scenario: Constructing a ray through a corner of the canvas
#   Given c ← camera(201, 101, π/2)
#   When r ← ray_for_pixel(c, 0, 0)
#   Then r.origin = point(0, 0, 0)
#     And r.direction = vector(0.66519, 0.33259, -0.66851)

# Scenario: Constructing a ray when the camera is transformed
#   Given c ← camera(201, 101, π/2)
#   When c.transform ← rotation_y(π/4) * translation(0, -2, 5)
#     And r ← ray_for_pixel(c, 100, 50)
#   Then r.origin = point(0, 2, -5)
#     And r.direction = vector(√2/2, 0, -√2/2)

# Scenario: Rendering a world with a camera
#   Given w ← default_world()
#     And c ← camera(11, 11, π/2)
#     And from ← point(0, 0, -5)
#     And to ← point(0, 0, 0)
#     And up ← vector(0, 1, 0)
#     And c.transform ← view_transform(from, to, up)
#   When image ← render(c, w)
#   Then pixel_at(image, 5, 5) = color(0.38066, 0.47583, 0.2855)
end
