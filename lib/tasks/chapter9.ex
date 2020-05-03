defmodule RayTracer.Tasks.Chapter9 do
  @moduledoc """
  This module tests camera from Chapter 9
  """

  alias RayTracer.RTuple
  alias RayTracer.Sphere
  alias RayTracer.Plane
  alias RayTracer.Canvas
  alias RayTracer.Material
  alias RayTracer.Color
  alias RayTracer.Light
  alias RayTracer.World
  alias RayTracer.Camera
  alias RayTracer.Matrix

  @r 4

  import RTuple, only: [point: 3, vector: 3]
  import Light, only: [point_light: 2]
  import RayTracer.Transformations

  @doc """
  Generates a file that tests rendering a world
  """
  @spec execute :: :ok
  def execute(w \\ 100, h \\ 50) do
    # RayTracer.Tasks.Chapter9.execute

    world = build_world()
    camera = build_camera(w, h)

    camera
    |> Camera.render(world)
    |> Canvas.export_to_ppm_file

    :ok
  end

  defp build_world do
    objects = [
      wall1, wall2, wall3, wall4, wall5, wall6, floor(), middle_sphere(), left_sphere(), right_sphere()
    ]
    light = point_light(point(0, 4, -2), Color.new(1, 1, 1))

    World.new(objects, light)
  end

  defp build_camera(w, h) do
    transform = view_transform(point(0, 6, -1.7), point(0, 1, 0), vector(0, 1, 0))

    Camera.new(w, h, :math.pi / 3, transform)
  end

  defp wall1 do
    transform =
      translation(0, 0, @r * :math.sqrt(3) / 2)
      |> Matrix.mult(rotation_y(0))
      |> Matrix.mult(rotation_x(:math.pi / 2))

    %Plane{floor() | material: %Material{Material.new | color: Color.new(1, 0, 0), specular: 0}, transform: transform}
  end

  defp wall2 do
    transform =
      translation(@r / 2, 0, @r * :math.sqrt(3) / 2)
      |> Matrix.mult(rotation_y(:math.pi / 3))
      |> Matrix.mult(rotation_x(:math.pi / 2))

    %Plane{floor() | material: %Material{Material.new | color: Color.new(0, 1, 0), specular: 0}, transform: transform}
  end

  defp wall3 do
    transform =
      translation(@r / 2, 0, -@r * :math.sqrt(3) / 2)
      |> Matrix.mult(rotation_y(2 * :math.pi / 3))
      |> Matrix.mult(rotation_x(:math.pi / 2))

    %Plane{floor() | material: %Material{Material.new | color: Color.new(0, 0, 1), specular: 0}, transform: transform}
  end

  defp wall4 do
    transform =
      translation(0, 0, -@r * :math.sqrt(3) / 2)
      |> Matrix.mult(rotation_y(:math.pi))
      |> Matrix.mult(rotation_x(:math.pi / 2))

    %Plane{floor() | material: %Material{Material.new | color: Color.new(1, 0, 0), specular: 0}, transform: transform}
  end

  defp wall5 do
    transform =
      translation(-@r / 2, 0, -@r * :math.sqrt(3) / 2)
      |> Matrix.mult(rotation_y(4 * :math.pi / 3))
      |> Matrix.mult(rotation_x(:math.pi / 2))

    %Plane{floor() | material: %Material{Material.new | color: Color.new(0, 1, 0), specular: 0}, transform: transform}
  end

  defp wall6 do
    transform =
      translation(-@r / 2, 0, @r * :math.sqrt(3) / 2)
      |> Matrix.mult(rotation_y(5 * :math.pi / 3))
      |> Matrix.mult(rotation_x(:math.pi / 2))

    %Plane{floor() | material: %Material{Material.new | color: Color.new(0, 0, 1), specular: 0}, transform: transform}
  end

  defp left_wall do
    transform =
      translation(0, 0, 4)
      |> Matrix.mult(rotation_y(-:math.pi / 4))
      |> Matrix.mult(rotation_x(:math.pi / 2))

    %Plane{floor() | transform: transform}
  end

  defp right_wall do
    transform =
      translation(0, 0, 4)
      |> Matrix.mult(rotation_y(:math.pi / 4))
      |> Matrix.mult(rotation_x(:math.pi / 2))

    %Plane{floor() | material: %Material{Material.new | color: Color.new(1, 0, 0), specular: 0}, transform: transform}
  end

  defp floor do
    material = %Material{Material.new | color: Color.new(1, 0.9, 0.9), specular: 0}
    %Plane{Plane.new | material: material}
  end

  defp left_sphere do
    transform = translation(-1.5, 0.33, -0.75) |> Matrix.mult(scaling(0.33, 0.33, 0.33))
    material = %Material{Material.new | color: Color.new(1, 0.8, 0.1), specular: 0.3, diffuse: 0.7}
    %Sphere{Sphere.new | material: material, transform: transform}
  end

  defp middle_sphere do
    transform = translation(0, 1, 0)
    material = %Material{Material.new | color: Color.new(0.1, 1, 0.5), specular: 0.3, diffuse: 0.7}
    %Sphere{Sphere.new | material: material, transform: transform}
  end

  defp right_sphere do
    transform = translation(1.5, 0.5, -0.5) |> Matrix.mult(scaling(0.5, 0.5, 0.5))
    material = %Material{Material.new | color: Color.new(0.5, 1, 0.1), specular: 0.3, diffuse: 0.7}
    %Sphere{Sphere.new | material: material, transform: transform}
  end
end
