defmodule GradientPatternTest do
  alias RayTracer.Color
  alias RayTracer.RTuple
  alias RayTracer.GradientPattern
  alias RayTracer.Pattern

  import Pattern, only: [pattern_at: 2]
  import RTuple, only: [point: 3]

  use ExUnit.Case
  doctest RayTracer.GradientPattern

  test "A gradient linearly interpolates between colors" do
    pattern = GradientPattern.new(Color.white, Color.black)

    assert pattern |> pattern_at(point(0, 0, 0)) == Color.white
    assert pattern |> pattern_at(point(0.25, 0, 0)) == Color.new(0.75, 0.75, 0.75)
    assert pattern |> pattern_at(point(0.5, 0, 0)) == Color.new(0.5, 0.5, 0.5)
    assert pattern |> pattern_at(point(0.75, 0, 0)) == Color.new(0.25, 0.25, 0.25)
  end
end
