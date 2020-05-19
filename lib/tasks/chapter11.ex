defmodule RayTracer.Tasks.Chapter11 do
  @moduledoc """
  This module tests camera from Chapter 11
  """

  alias RayTracer.RTuple
  alias RayTracer.Shape
  alias RayTracer.Sphere
  alias RayTracer.Plane
  alias RayTracer.Canvas
  alias RayTracer.Material
  alias RayTracer.Color
  alias RayTracer.Light
  alias RayTracer.World
  alias RayTracer.Camera
  alias RayTracer.Matrix
  alias RayTracer.CheckerPattern

  import RTuple, only: [point: 3, vector: 3]
  import Light, only: [point_light: 2]
  import RayTracer.Transformations

  @doc """
  Generates a file that tests rendering a world
  """
  @spec execute :: :ok
  def execute(w \\ 100, h \\ 50) do
    # Benchmark(fn -> RayTracer.Tasks.Chapter11.execute end)
    Counter.start_link(0)

    world = build_world()
    camera = build_camera(w, h)

    camera
    |> Camera.render(world)
    |> Canvas.export_to_ppm_file

    IO.puts("Counter: #{Counter.value}")
    :ok
  end

  defp build_world do
    objects = [
      floor(), left_sphere(), middle_sphere(), right_sphere()
    ]
    light = point_light(point(-10, 10, -10), Color.new(1, 1, 1))

    World.new(objects, light)
  end

  defp build_camera(w, h) do
    transform = view_transform(point(0, 1.5, -5), point(0, 1, 0), vector(0, 1, 0))

    Camera.new(w, h, :math.pi / 3, transform)
  end

  defp floor do
    pattern = CheckerPattern.new(Color.black, Color.white)
    material = %Material{specular: 0, reflective: 0.5, pattern: pattern}
    %Plane{material: material}
  end

  defp left_sphere do
    transform = translation(-1.5, 0.33, -0.75) |> Matrix.mult(scaling(0.33, 0.33, 0.33))
    material = %Material{Material.new | color: Color.new(1, 0.8, 0.1), specular: 0.3, diffuse: 0.7}
    %Sphere{Sphere.new | material: material} |> Shape.set_transform(transform)
  end

  defp middle_sphere do
    transform = translation(-0.5, 1, 0.5)
    material = %Material{specular: 0.3, diffuse: 0.7, color: Color.new(1, 0, 0)}
    %Sphere{Sphere.new | material: material} |> Shape.set_transform(transform)
  end

  defp right_sphere do
    transform = translation(1.5, 0.5, -0.5) |> Matrix.mult(scaling(0.5, 0.5, 0.5))
    material = %Material{specular: 0.3, diffuse: 0.7}
    %Sphere{Sphere.new | material: material} |> Shape.set_transform(transform)
  end
end
