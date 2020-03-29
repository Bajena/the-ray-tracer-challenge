defmodule RayTracer.Intersection do
  @moduledoc """
  This module is responsible for computing ray intersections with various shapes
  """

  alias RayTracer.Sphere
  alias RayTracer.Ray
  alias RayTracer.RTuple

  import RTuple, only: [sub: 2, dot: 2]

  @type t :: %__MODULE__{
    t: number,
    object: Sphere.t
  }

  defstruct [:t, :object]

  @doc """
  Builds an intersection of ray with shape `s` at distance `t`
  """
  @spec new(number, Sphere.t) :: t
  def new(t, s) do
    %__MODULE__{t: t, object: s}
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

    if discriminant < 0 do
     []
    else
      dsqrt = :math.sqrt(discriminant)
      [(-b - dsqrt) / 2 * a, (-b + dsqrt) / 2 * a]
    end |> Enum.map(&new(&1, sphere))
  end

  @doc """
  Returns a first non-negative intersection from intersections list
  """
  @spec hit(list(t)) :: t
  def hit(intersections) do
    intersections
    |> Enum.reject(fn(i) -> i.t < 0 end)
    |> Enum.min_by(&(&1.t), fn -> nil end)
  end
end
