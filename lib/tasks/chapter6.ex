defmodule RayTracer.Tasks.Chapter6 do
  @moduledoc """
  This module tests simple ray-sphere intersections from Chapter 6
  """

  alias RayTracer.RTuple
  alias RayTracer.Ray
  alias RayTracer.Sphere
  alias RayTracer.Intersection
  alias RayTracer.Canvas
  alias RayTracer.Material
  alias RayTracer.Color
  alias RayTracer.Light

  import Intersection, only: [intersect: 2]
  import RTuple, only: [point: 3, normalize: 1]
  import Light, only: [point_light: 2]
  import RayTracer.Transformations

  @doc """
  Generates a file that tests Phong shaded sphere
  """
  @spec execute :: :ok
  def execute do
    ray_origin = point(0, 0, -5)
    wall_z = 10
    wall_size = 7
    canvas_pixels = 200
    pixel_size = wall_size / canvas_pixels
    half = wall_size / 2

    canvas = Canvas.new(canvas_pixels, canvas_pixels)
    material = %Material{Material.new | color: Color.new(1, 0.2, 0.6)}
    transform = scaling(1, 0.5, 1)
    sphere = %Sphere{Sphere.new | material: material, transform: transform}
    light = point_light(point(-10, 10, -10), Color.white)

    range = 0..(canvas_pixels - 1)

    Enum.reduce(range, canvas, fn y, canvas ->
      if rem(y, 10) == 0, do: IO.puts("#{y}/#{canvas_pixels}")
      world_y = half - pixel_size * y

      Enum.reduce(range, canvas, fn x, canvas ->
        world_x = -half + pixel_size * x

        position = point(world_x, world_y, wall_z)

        ray = Ray.new(ray_origin, normalize(position |> RTuple.sub(ray_origin)))
        xs = intersect(sphere, ray)

        if hit = Intersection.hit(xs) do
          hit_at = ray |> Ray.position(hit.t)
          normal = hit.object |> Sphere.normal_at(hit_at)
          eye = RTuple.negate(ray.direction)
          color = Light.lighting(hit.object.material, hit.object, light, hit_at, eye, normal, false)
          canvas |> Canvas.write_pixel(x, y, color)
        else
          canvas
        end
      end)
    end) |> Canvas.export_to_ppm_file

    :ok
  end
end
