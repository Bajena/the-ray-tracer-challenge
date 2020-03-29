defmodule RayTracer.Intersection do
  @moduledoc """
  This module is responsible for computing ray intersections with various shapes
  """

  alias RayTracer.Sphere
  alias RayTracer.Ray
  alias RayTracer.RTuple

  import RTuple, only: [sub: 2, dot: 2]

  @type t :: %__MODULE__{
    t: number
  }

  defstruct [:t]

  @doc """
  Builds an intersection of ray with shape at distance `t`
  """
  @spec new(number) :: t
  def new(t) do
    %__MODULE__{t: t}
  end

  @doc """
  Builds an intersection of ray with shape at distance `t`
  """
  @spec intersect(Sphere.t, Ray.t) :: list(t)
  def intersect(sphere = %Sphere{}, ray = %Ray{}) do
    sphere_to_ray = sub(ray.origin, sphere.center)
    a = dot(ray.direction, ray.direction)
    b = 2 * dot(ray.direction, sphere_to_ray)
    c = dot(sphere_to_ray, sphere_to_ray) - sphere.r

    discriminant = b * b - 4 * a * c

    cond do
      discriminant < 0 -> []
        discriminant >= 0 ->
        dsqrt = :math.sqrt(discriminant)
        [(-b - dsqrt) / 2 * a, (-b + dsqrt) / 2 * a]
    end |> Enum.map(&new(&1))
  end
end
