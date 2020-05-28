defmodule CameraTest do
  alias RayTracer.Camera
  alias RayTracer.Matrix
  alias RayTracer.Transformations
  alias RayTracer.World
  alias RayTracer.RTuple
  alias RayTracer.Canvas
  alias RayTracer.Color

  import RTuple.CustomOperators
  import RayTracer.General
  import RTuple, only: [point: 3, vector: 3]
  import Transformations, only: [rotation_y: 1, translation: 3, view_transform: 3]

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

    assert c.pixel_size |> round_eps == 0.01
  end

  test "The pixel size for a vertical canvas" do
    c = Camera.new(200, 125, :math.pi / 2)

    assert c.pixel_size |> round_eps == 0.01
  end

  test "Constructing a ray through the center of the canvas" do
    c = Camera.new(201, 101, :math.pi / 2)
    r = c |> Camera.ray_for_pixel(100, 50)

    assert r.origin <~> point(0, 0, 0)
    assert r.direction <~> vector(0, 0, -1)
  end

  test "Constructing a ray through a corner of the canvas" do
    c = Camera.new(201, 101, :math.pi / 2)
    r = c |> Camera.ray_for_pixel(0, 0)

    assert r.origin <~> point(0, 0, 0)
    assert r.direction <~> vector(0.66519, 0.33259, -0.66851)
  end

  test "Constructing a ray when the camera is transformed" do
    t = Transformations.compose([
      translation(0, -2, 5),
      rotation_y(:math.pi / 4)
    ])
    c = Camera.new(201, 101, :math.pi / 2, t)
    r = c |> Camera.ray_for_pixel(100, 50)

    assert r.origin <~> point(0, 2, -5)
    assert r.direction <~> vector(:math.sqrt(2) / 2, 0, -:math.sqrt(2) / 2)
  end

  test "Rendering a world with a camera" do
    w = World.default()
    from = point(0, 0, -5)
    to = point(0, 0, 0)
    up = vector(0, 1, 0)
    c = Camera.new(11, 11, :math.pi / 2, view_transform(from, to, up))

    canvas = Camera.render(c, w)

    assert canvas |> Canvas.pixel_at(5, 5) <~> Color.new(0.38066, 0.47583, 0.2855)
  end
end
