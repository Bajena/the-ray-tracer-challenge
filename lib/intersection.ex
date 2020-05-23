defmodule RayTracer.Intersection do
  @moduledoc """
  This module is responsible for computing ray intersections with various shapes
  """

  alias RayTracer.Shape
  alias RayTracer.Ray
  alias RayTracer.RTuple
  alias RayTracer.World

  import RayTracer.Constants

  @type t :: %__MODULE__{
    t: number,
    object: Shape.t
  }

  @type intersections :: list(t)

  @type computation :: %{
    t: number,
    object: Shape.t,
    point: RTuple.point,
    eyev: RTuple.vector,
    normalv: RTuple.vector,
    inside: boolean,
    over_point: RTuple.point,
    reflectv: RTuple.vector,
    n1: number,
    n2: number
  }

  defstruct [:t, :object]

  @doc """
  Builds an intersection of ray with shape `s` at distance `t`
  """
  @spec new(number, Shape.t) :: t
  def new(t, s) do
    %__MODULE__{t: t, object: s}
  end

  @doc """
  Builds intersectons
  """
  @spec intersections(list({number, Shape.t})) :: intersections
  def intersections(xs) do
    xs |> Enum.map(
      fn ({t, s}) -> new(t, s) end
    )
  end

  @doc """
  Builds an intersection of ray with shape at distance `t`
  """
  @spec intersect(Shape.t, Ray.t) :: intersections
  def intersect(shape, ray) do
    object_space_ray = ray |> Ray.transform(shape.inv_transform)

    Shape.local_intersect(shape, object_space_ray)
  end

  @doc """
  Builds an intersection of ray with world `w`
  """
  @spec intersect_world(World.t, Ray.t) :: intersections
  def intersect_world(world, ray) do
    world.objects
    |> Enum.flat_map(&intersect(&1, ray))
    |> Enum.sort_by(&(&1.t))
  end

  @doc """
  Returns a first non-negative intersection from intersections list.
  Assumes that intersections list is sorted by t.
  """
  @spec hit(intersections) :: t | nil
  def hit(intersections) do
    intersections
    |> Enum.reject(fn(i) -> i.t < 0 end)
    |> Enum.at(0)
    |> Enum.min_by(&(&1.t), fn -> nil end)
  end

  @doc """
  Prepares data for shading computations
  """
  @spec prepare_computations(t, Ray.t, intersections) :: computation
  def prepare_computations(intersection, ray) do
    prepare_computations(intersection, ray, [intersection])
  end
  def prepare_computations(intersection, ray, xs) do
    p = ray |> Ray.position(intersection.t)
    eyev = RTuple.negate(ray.direction)
    normalv = intersection.object |> Shape.normal_at(p)
    inside = inside?(normalv, eyev)
    final_normal_v = (if inside, do: RTuple.negate(normalv), else: normalv)

    {n1, n2} = intersection |> comp_n1_n2(xs)

    %{
      t: intersection.t,
      object: intersection.object,
      point: p,
      eyev: eyev,
      normalv: final_normal_v,
      inside: inside,
      over_point: p |> RTuple.add(final_normal_v |> RTuple.mul(epsilon())),
      reflectv: ray |> Ray.reflect(final_normal_v),
      n1: n1,
      n2: n2
    }
  end

  # Tests if the intersection occured inside the object
  @spec inside?(RTuple.vector, RTuple.vector) :: boolean
  defp inside?(normalv, eyev) do
    RTuple.dot(normalv, eyev) < 0
  end

  # Given a hit and a list of intersections computes refractive indices of the
  # materials on either side of a ray-object intersection with:
  # n1 - belonging to the material being exited
  # n2 - belonging to the material being entered
  @spec comp_n1_n2(t, intersections) :: {number, number}
  defp comp_n1_n2(intersection, xs) do
    comp_n1_n2(intersection, xs, 1,  1, [])
  end
  defp comp_n1_n2(_intersection, [], n1, n2, _containers), do: {n1, n2}
  defp comp_n1_n2(intersection, [i | rest_xs], n1, n2, containers) do
    n1_new = calc_new_n(n1, i, intersection, containers)

    containers_new = append_or_remove(containers, i.object)

    n2_new = calc_new_n(n2, i, intersection, containers_new)

    comp_n1_n2(intersection, rest_xs, n1_new, n2_new, containers_new)
  end

  defp calc_new_n(current_n, i, intersection, containers) do
    if i == intersection do
      if containers |> Enum.empty? do
        1
      else
        Enum.at(containers, -1).material.refractive_index
      end
    else
      current_n
    end
  end

  defp append_or_remove(containers, object) do
    index = containers |> Enum.find_index(fn x -> x == object end)

    if index do
      containers |> List.delete_at(index)
    else
      containers |> List.insert_at(-1, object)
    end
  end
end
