defmodule RayTracer.Tasks.Chapter7 do
  @moduledoc """
  This module tests camera from Chapter 7
  """

  alias RayTracer.RTuple
  alias RayTracer.Ray
  alias RayTracer.Sphere
  alias RayTracer.Intersection
  alias RayTracer.Canvas
  alias RayTracer.Material
  alias RayTracer.Color
  alias RayTracer.Light
  alias RayTracer.World
  alias RayTracer.Camera
  alias RayTracer.Matrix

  import Intersection, only: [intersect: 2]
  import RTuple, only: [point: 3, vector: 3, normalize: 1]
  import Light, only: [point_light: 2]
  import RayTracer.Transformations

  @doc """
  Generates a file that tests rendering a world
  """
  @spec execute :: :ok
  def execute(w \\ 100, h \\ 50) do
    # RayTracer.Tasks.Chapter7.execute

    world = build_world
    camera = build_camera(w, h)

    camera
    |> Camera.render(world)
    |> Canvas.export_to_ppm_file

    :ok
  end

  defp build_world do
    objects = [
      left_wall, right_wall, floor, left_sphere, middle_sphere, right_sphere
    ]
    light = point_light(point(-10, 10, -10), Color.new(1, 1, 1))

    World.new(objects, light)
  end

  defp build_camera(w, h) do
    transform = view_transform(point(0, 1.5, -5), point(0, 1, 0), vector(0, 1, 0))

    Camera.new(w, h, :math.pi / 3, transform)
  end

  defp left_wall do
    transform =
      translation(0, 0, 5)
      |> Matrix.mult(rotation_y(-:math.pi / 4))
      |> Matrix.mult(rotation_x(:math.pi / 2))
      |> Matrix.mult(scaling(10, 0.01, 10))

    %Sphere{floor | transform: transform}
  end

  defp right_wall do
    transform =
      translation(0, 0, 5)
      |> Matrix.mult(rotation_y(:math.pi / 4))
      |> Matrix.mult(rotation_x(:math.pi / 2))
      |> Matrix.mult(scaling(10, 0.01, 10))

    %Sphere{floor | transform: transform}
  end

  defp floor do
    transform = scaling(10, 0.01, 10)
    material = %Material{Material.new | color: Color.new(1, 0.9, 0.9), specular: 0}
    %Sphere{Sphere.new | material: material, transform: transform}
  end

  defp left_sphere do
    transform = translation(-1.5, 0.33, -0.75) |> Matrix.mult(scaling(0.33, 0.33, 0.33))
    material = %Material{Material.new | color: Color.new(1, 0.8, 0.1), specular: 0.3, diffuse: 0.7}
    %Sphere{Sphere.new | material: material, transform: transform}
  end

  defp middle_sphere do
    transform = translation(-0.5, 1, 0.5)
    material = %Material{Material.new | color: Color.new(0.1, 1, 0.5), specular: 0.3, diffuse: 0.7}
    %Sphere{Sphere.new | material: material, transform: transform}
  end

  defp right_sphere do
    transform = translation(1.5, 0.5, -0.5) |> Matrix.mult(scaling(0.5, 0.5, 0.5))
    material = %Material{Material.new | color: Color.new(0.5, 1, 0.1), specular: 0.3, diffuse: 0.7}
    %Sphere{Sphere.new | material: material, transform: transform}
  end
end
