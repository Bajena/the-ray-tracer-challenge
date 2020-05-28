defmodule RayTracer.Tasks.Chapter11 do
  @moduledoc """
  This module tests reflections and refractions from Chapter 11
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
  alias RayTracer.Pattern
  alias RayTracer.StripePattern
  alias RayTracer.CheckerPattern
  alias RayTracer.Transformations

  import RTuple, only: [point: 3, vector: 3]
  import Light, only: [point_light: 2]
  import Transformations

  @doc """
  Generates a file that tests rendering a world
  """
  @spec execute :: :ok
  def execute(w \\ 100, h \\ 50) do
    # Benchmark(fn -> RayTracer.Tasks.Chapter11.execute end)
    world = build_world()
    camera = build_camera(w, h)

    camera
    |> Camera.render(world)
    |> Canvas.export_to_ppm_file

    :ok
  end

  defp build_world do
    objects = [
      floor(),
      ceiling(),
      west_wall(),
      east_wall(),
      north_wall(),
      south_wall(),
      red_sphere(),
      blue_glass_sphere(),
      green_glass_sphere()
    ]
    light = point_light(point(-4.9, 4.9, -1), Color.new(1, 1, 1))

    World.new(objects, light)
  end

  defp build_camera(w, h) do
    transform = view_transform(point(-2.6, 1.5, -3.9), point(-0.6, 1, -0.8), vector(0, 1, 0))

    Camera.new(w, h, 1.152, transform)
  end

  defp wall_material do
    transform = Transformations.compose([
      scaling(0.25, 0.25, 0.25),
      rotation_y(1.5708)
    ])
    pattern = StripePattern.new(Color.new(0.45, 0.45, 0.45), Color.new(0.55, 0.55, 0.55)) |> Pattern.set_transform(transform)

    %Material{
      pattern: pattern,
      ambient: 0,
      diffuse: 0.4,
      specular: 0,
      reflective: 0.3
    }
  end

  def floor do
    pattern = CheckerPattern.new(Color.new(0.35, 0.35, 0.35), Color.new(0.65, 0.65, 0.65))
    material = %Material{specular: 0, reflective: 0.4, pattern: pattern}
    transform = rotation_y(0.31415)
    %Plane{material: material} |> Shape.set_transform(transform)
  end

  def ceiling do
    material = %Material{color: Color.new(0.8, 0.8, 0.8), specular: 0, ambient: 0.3}
    transform = translation(0, 5, 0)
    %Plane{material: material} |> Shape.set_transform(transform)
  end

  def west_wall do
    transform = Transformations.compose([
      rotation_y(1.5708),
      rotation_z(1.5708),
      translation(-5, 0, 0)
    ])
    %Plane{material: wall_material()} |> Shape.set_transform(transform)
  end

  def east_wall do
    transform = Transformations.compose([
      rotation_y(1.5708),
      rotation_z(1.5708),
      translation(5, 0, 0)
    ])
    %Plane{material: wall_material()} |> Shape.set_transform(transform)
  end

  def north_wall do
    transform = Transformations.compose([
      rotation_x(1.5708),
      translation(0, 0, 5)
    ])
    %Plane{material: wall_material()} |> Shape.set_transform(transform)
  end

  def south_wall do
    transform = Transformations.compose([
      rotation_x(1.5708),
      translation(0, 0, -5)
    ])
    %Plane{material: wall_material()} |> Shape.set_transform(transform)
  end

  def red_sphere do
    transform = Transformations.compose([
      translation(-0.6, 1, 0.6)
    ])

    material = %Material{
      color: Color.new(1, 0.3, 0.2),
      specular: 0.4,
      shininess: 5
    }
    %Sphere{material: material} |> Shape.set_transform(transform)
  end

  def blue_glass_sphere do
    transform = Transformations.compose([
      scaling(0.7, 0.7, 0.7),
      translation(0.6, 0.7, -0.6)
    ])

    material = %Material{
      color: Color.new(0, 0, 0.2),
      ambient: 0,
      diffuse: 0.4,
      specular: 0.9,
      shininess: 300,
      reflective: 0.9,
      transparency: 0.9,
      refractive_index: 1.5
    }
    %Sphere{material: material} |> Shape.set_transform(transform)
  end

  def green_glass_sphere do
    transform = Transformations.compose([
      scaling(0.5, 0.5, 0.5),
      translation(-0.7, 0.5, -0.8)
    ])

    material = %Material{
      color: Color.new(0, 0.2, 0),
      ambient: 0,
      diffuse: 0.4,
      specular: 0.9,
      shininess: 300,
      reflective: 0.9,
      transparency: 0.9,
      refractive_index: 1.5
    }
    %Sphere{material: material} |> Shape.set_transform(transform)
  end
end
