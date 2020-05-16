defmodule RayTracer.Tasks.Chapter11 do
  @moduledoc """
  This module tests camera from Chapter 11
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
  alias RayTracer.StripePattern
  alias RayTracer.GradientPattern
  alias RayTracer.RingPattern
  alias RayTracer.CheckerPattern
  alias RayTracer.BlendedPattern

  import RTuple, only: [point: 3, vector: 3]
  import Light, only: [point_light: 2]
  import RayTracer.Transformations

  @doc """
  Generates a file that tests rendering a world
  """
  @spec execute :: :ok
  def execute(w \\ 100, h \\ 50) do
    # RayTracer.Tasks.Chapter11.execute

    world = build_world()
    camera = build_camera(w, h)

    camera
    |> Camera.render(world)
    |> Canvas.export_to_ppm_file

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

  defp back_wall do
    transform =
      translation(0, 0, 2.5)
      |> Matrix.mult(rotation_x(:math.pi / 2))

    a = StripePattern.new(Color.black, Color.white)
    b = StripePattern.new(Color.new_from_rgb_255(255, 0, 0), Color.white, rotation_y(:math.pi / 2))
    pattern = %BlendedPattern{a: a, b: b, transform: rotation_z(:math.pi / 4)}
    material = %Material{specular: 0, pattern: pattern}
    %Plane{transform: transform, material: material}
  end

  defp floor do
    pattern = CheckerPattern.new(Color.black, Color.white)
    material = %Material{specular: 0, reflective: 0.5, pattern: pattern}
    %Plane{material: material}
  end

  defp left_sphere do
    transform = translation(-1.5, 0.33, -0.75) |> Matrix.mult(scaling(0.33, 0.33, 0.33))
    pattern = GradientPattern.new(Color.new(1, 1, 1), Color.new_from_rgb_255(68, 112, 43), scaling(2, 1, 1) |> Matrix.mult(translation(0.5, 0, 0)))
    material = %Material{Material.new | color: Color.new(1, 0.8, 0.1), specular: 0.3, diffuse: 0.7}
    %Sphere{Sphere.new | material: material, transform: transform}
  end

  defp middle_sphere do
    transform = translation(-0.5, 1, 0.5)
    pattern = RingPattern.new(Color.new(1, 1, 1), Color.new_from_rgb_255(68, 112, 43), scaling(0.2, 0.2, 0.2) |> Matrix.mult(rotation_x(:math.pi / 2)))
    material = %Material{specular: 0.3, diffuse: 0.7, color: Color.new(1, 0, 0)}
    %Sphere{Sphere.new | material: material, transform: transform}
  end

  defp right_sphere do
    transform = translation(1.5, 0.5, -0.5) |> Matrix.mult(scaling(0.5, 0.5, 0.5))
    # pattern = StripePattern.new(Color.new(1, 1, 1), Color.new_from_rgb_255(68, 112, 43), scaling(0.2, 1, 1))
    material = %Material{specular: 0.3, diffuse: 0.7}
    %Sphere{Sphere.new | material: material, transform: transform}
  end
end
