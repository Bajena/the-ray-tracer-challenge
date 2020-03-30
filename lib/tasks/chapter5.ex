defmodule RayTracer.Tasks.Chapter5 do
  @moduledoc """
  This module tests simple ray-sphere intersections from Chapter 5
  """

  alias RayTracer.RTuple
  alias RayTracer.Ray
  alias RayTracer.Sphere
  alias RayTracer.Intersection
  alias RayTracer.Canvas
  alias RayTracer.Color

  import Intersection, only: [intersect: 2, hit: 1]
  import RTuple, only: [point: 3, normalize: 1]

  @doc """
  Generates a file that tests simple ray-sphere intersections
  """
  @spec execute :: :ok
  def execute do
    ray_origin = point(0, 0, -5)
    wall_z = 10
    wall_size = 7
    canvas_pixels = 100
    pixel_size = wall_size / canvas_pixels
    half = wall_size / 2

    canvas = Canvas.new(canvas_pixels, canvas_pixels)
    color = Color.new(1, 0, 0)
    sphere = Sphere.new

    range = 0..(canvas_pixels - 1)

    Enum.reduce(range, canvas, fn y, canvas ->
      world_y = half - pixel_size * y

      Enum.reduce(range, canvas, fn x, canvas ->
        world_x = -half + pixel_size * x

        position = point(world_x, world_y, wall_z)

        r = Ray.new(ray_origin, normalize(position |> RTuple.sub(ray_origin)))
        xs = intersect(sphere, r)

        if hit(xs) do
          canvas |> Canvas.write_pixel(x, y, color)
        else
          canvas
        end
      end)
    end) |> Canvas.export_to_ppm_file

    :ok
  end
end
