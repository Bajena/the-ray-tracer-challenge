defmodule RayTracer.World do
  @moduledoc """
  This module defines world. World is a bag for elements like objects and light sources.
  """

  alias RayTracer.Light
  alias RayTracer.Sphere
  alias RayTracer.Shape
  alias RayTracer.Material
  alias RayTracer.Transformations
  alias RayTracer.RTuple
  alias RayTracer.Color
  alias RayTracer.Intersection
  alias RayTracer.Ray

  @type t :: %__MODULE__{
    objects: list(Shape.t),
    light: Light.t | nil
  }

  defstruct [:objects, :light]

  @doc """
  Builds a world with given objects and light
  """
  @spec new(list(Shape.t), Light.t | nil) :: t
  def new(objects \\ [], light \\ nil) do
    %__MODULE__{objects: objects, light: light}
  end

  @doc """
  Builds a default world containing some objects and light
  """
  @spec default() :: t
  def default() do
    material = %Material{Material.new | color: Color.new(0.8, 1.0, 0.6), diffuse: 0.7, specular: 0.2}
    s1 = %Sphere{Sphere.new | material: material}

    s2 = Sphere.new |> Shape.set_transform(Transformations.scaling(0.5, 0.5, 0.5))

    light = Light.point_light(RTuple.point(-10, 10, -10), Color.white)

    new([s1, s2], light)
  end

  @doc """
  Computes shading for a ray hitting a world
  """
  @spec color_at(t, Ray.t, integer) :: Color.t
  def color_at(world, ray, remaining \\ 4) do
    hit = world |> ray_hit(ray)

    if hit do
      world |> shade_hit(hit |> Intersection.prepare_computations(ray), remaining)
    else
      Color.black
    end
  end

  @doc """
  Shades an intersection
  """
  @spec shade_hit(t, Intersection.computation, integer) :: Color.t
  def shade_hit(world, comps, remaining \\ 4) do
    surface = Light.lighting(
      comps.object.material,
      comps.object,
      world.light,
      comps.over_point,
      comps.eyev,
      comps.normalv,
      world |> is_shadowed(comps.over_point)
    )

    reflected = world |> reflected_color(comps, remaining)

    Color.add(surface, reflected)
  end

  @doc """
  Computes a color for reflection
  """
  @spec reflected_color(t, Intersection.computation, integer) :: Color.t
  def reflected_color(_, _, remaining \\ 4)
  def reflected_color(_, _, 0), do: Color.black
  def reflected_color(_, %{object: %{material: %{reflective: r }}}, _) when r == 0, do: Color.black
  def reflected_color(world, comps, remaining) do
    reflect_ray = Ray.new(comps.over_point, comps.reflectv)
    color = world |> color_at(reflect_ray, remaining - 1)

    color |> Color.mul(comps.object.material.reflective)
  end

  @doc """
  Informs whether a given point is in shadow
  """
  @spec is_shadowed(t, RTuple.point) :: boolean
  def is_shadowed(world, point) do
    point_to_light_vector = RTuple.sub(world.light.position, point)
    distance = point_to_light_vector |> RTuple.length
    shadow_ray = Ray.new(point, point_to_light_vector  |> RTuple.normalize)

    shadow_hit = world |> ray_hit(shadow_ray)

    shadow_hit != nil && shadow_hit.t < distance
  end

  # Returns a closest ray hit
  defp ray_hit(world, ray) do
    world
    |> Intersection.intersect_world(ray)
    |> Intersection.hit
  end
end
