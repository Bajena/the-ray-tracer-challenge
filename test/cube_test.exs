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

  # Scenario Outline: A ray intersects a cube
  #   Given c ← cube()
  #     And r ← ray(<origin>, <direction>)
  #   When xs ← local_intersect(c, r)
  #   Then xs.count = 2
  #     And xs[0].t = <t1>
  #     And xs[1].t = <t2>

  #   Examples:
  #     |        | origin            | direction        | t1 | t2 |
  #     | +x     | point(5, 0.5, 0)  | vector(-1, 0, 0) |  4 |  6 |
  #     | -x     | point(-5, 0.5, 0) | vector(1, 0, 0)  |  4 |  6 |
  #     | +y     | point(0.5, 5, 0)  | vector(0, -1, 0) |  4 |  6 |
  #     | -y     | point(0.5, -5, 0) | vector(0, 1, 0)  |  4 |  6 |
  #     | +z     | point(0.5, 0, 5)  | vector(0, 0, -1) |  4 |  6 |
  #     | -z     | point(0.5, 0, -5) | vector(0, 0, 1)  |  4 |  6 |
  #     | inside | point(0, 0.5, 0)  | vector(0, 0, 1)  | -1 |  1 |

  # Scenario Outline: A ray misses a cube
  #   Given c ← cube()
  #     And r ← ray(<origin>, <direction>)
  #   When xs ← local_intersect(c, r)
  #   Then xs.count = 0

  #   Examples:
  #     | origin           | direction                      |
  #     | point(-2, 0, 0)  | vector(0.2673, 0.5345, 0.8018) |
  #     | point(0, -2, 0)  | vector(0.8018, 0.2673, 0.5345) |
  #     | point(0, 0, -2)  | vector(0.5345, 0.8018, 0.2673) |
  #     | point(2, 0, 2)   | vector(0, 0, -1)               |
  #     | point(0, 2, 2)   | vector(0, -1, 0)               |
  #     | point(2, 2, 0)   | vector(-1, 0, 0)               |


  # Scenario Outline: The normal on the surface of a cube
  #   Given c ← cube()
  #     And p ← <point>
  #   When normal ← local_normal_at(c, p)
  #   Then normal = <normal>

  #   Examples:
  #     | point                | normal           |
  #     | point(1, 0.5, -0.8)  | vector(1, 0, 0)  |
  #     | point(-1, -0.2, 0.9) | vector(-1, 0, 0) |
  #     | point(-0.4, 1, -0.1) | vector(0, 1, 0)  |
  #     | point(0.3, -1, -0.7) | vector(0, -1, 0) |
  #     | point(-0.6, 0.3, 1)  | vector(0, 0, 1)  |
  #     | point(0.4, 0.4, -1)  | vector(0, 0, -1) |
  #     | point(1, 1, 1)       | vector(1, 0, 0)  |
  #     | point(-1, -1, -1)    | vector(-1, 0, 0) |
end
