defmodule CheckerPatternTest do
  alias RayTracer.Color
  alias RayTracer.RTuple
  alias RayTracer.CheckerPattern
  alias RayTracer.Pattern

  import Pattern, only: [pattern_at: 2]
  import RTuple, only: [point: 3]

  use ExUnit.Case
  doctest RayTracer.CheckerPattern

  test "Checkers should repeat in x" do
    pattern = CheckerPattern.new(Color.white, Color.black)

    assert pattern |> pattern_at(point(0, 0, 0)) == Color.white
    assert pattern |> pattern_at(point(0.99, 0, 0)) == Color.white
    assert pattern |> pattern_at(point(1.01, 0, 0)) == Color.black
  end

  test "Checkers should repeat in y" do
    pattern = CheckerPattern.new(Color.white, Color.black)

    assert pattern |> pattern_at(point(0, 0, 0)) == Color.white
    assert pattern |> pattern_at(point(0, 0.99, 0)) == Color.white
    assert pattern |> pattern_at(point(0, 1.01, 0)) == Color.black
  end
end
