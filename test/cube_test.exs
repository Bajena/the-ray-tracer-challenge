defmodule CubeTest do
  alias RayTracer.RTuple
  alias RayTracer.Ray
  alias RayTracer.Cube
  alias RayTracer.Shape
  import RTuple, only: [point: 3, vector: 3]

  use ExUnit.Case
  doctest RayTracer.Cube

  combinations = [
    {"+x", (quote do: point(5, 0.5, 0)), (quote do: vector(-1, 0, 0)), 4, 6},
    {"-x", (quote do: point(-5, 0.5, 0)), (quote do: vector(1, 0, 0)), 4, 6},
    {"+y", (quote do: point(0.5, 5, 0)), (quote do: vector(0, -1, 0)), 4, 6},
    {"-y", (quote do: point(0.5, -5, 0)), (quote do: vector(0, 1, 0)), 4, 6},
    {"+z", (quote do: point(0.5, 0, 5)), (quote do: vector(0, 0, -1)), 4, 6},
    {"-z", (quote do: point(0.5, 0, -5)), (quote do: vector(0, 0, 1)), 4, 6},
    {"inside", (quote do: point(0, 0.5, 0)), (quote do: vector(0, 0, 1)), -1, 1}
  ]

  for {title, origin, direction, t1, t2} <- combinations do
    test "A ray intersects a cube (#{title}, #{Macro.to_string(origin)}, #{Macro.to_string(direction)}, #{t1}, #{t2})" do
      origin = unquote(origin)
      direction = unquote(direction)
      t1 = unquote(t1)
      t2 = unquote(t2)

      c = Cube.new()
      r = Ray.new(origin, direction)
      xs = Shape.local_intersect(c, r)

      assert Enum.at(xs, 0).t == t1
      assert Enum.at(xs, 1).t == t2
    end
  end

  combinations = [
    {(quote do: point(-2, 0, 0)), (quote do: vector(0.2673, 0.5345, 0.8018))},
    {(quote do: point(0, -2, 0)), (quote do: vector(0.8018, 0.2673, 0.5345))},
    {(quote do: point(0, 0, -2)), (quote do: vector(0.5345, 0.8018, 0.2673))},
    {(quote do: point(2, 0, 2)), (quote do: vector(0, 0, -1))},
    {(quote do: point(0, 2, 2)), (quote do: vector(0, -1, 0))},
    {(quote do: point(2, 2, 0)), (quote do: vector(-1, 0, 0))}
  ]

  for {origin, direction} <- combinations do
    test "A ray misses a cube (#{Macro.to_string(origin)}, #{Macro.to_string(direction)})" do
      origin = unquote(origin)
      direction = unquote(direction)

      c = Cube.new()
      r = Ray.new(origin, direction)
      xs = Shape.local_intersect(c, r)

      assert Enum.empty?(xs)
    end
  end

  combinations = [
    {(quote do: point(1, 0.5, -0.8)), (quote do: vector(1, 0, 0))},
    {(quote do: point(-1, -0.2, 0.9)), (quote do: vector(-1, 0, 0))},
    {(quote do: point(-0.4, 1, -0.1)), (quote do: vector(0, 1, 0))},
    {(quote do: point(0.3, -1, -0.7)), (quote do: vector(0, -1, 0))},
    {(quote do: point(-0.6, 0.3, 1)), (quote do: vector(0, 0, 1))},
    {(quote do: point(0.4, 0.4, -1)), (quote do: vector(0, 0, -1))},
    {(quote do: point(1, 1, 1)), (quote do: vector(1, 0, 0))},
    {(quote do: point(-1, -1, -1)), (quote do: vector(-1, 0, 0))}
  ]

  for {p, normal} <- combinations do
    test "The normal on the surface of a cube (#{Macro.to_string(p)}, #{Macro.to_string(normal)})" do
      p = unquote(p)
      normal = unquote(normal)

      c = Cube.new()

      assert Shape.local_normal_at(c, p) == normal
    end
  end
end
