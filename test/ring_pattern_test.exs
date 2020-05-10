defmodule RingPatternTest do
  alias RayTracer.Color
  alias RayTracer.RTuple
  alias RayTracer.RingPattern
  alias RayTracer.Pattern

  import Pattern, only: [pattern_at: 2]
  import RTuple, only: [point: 3]

  use ExUnit.Case
  doctest RayTracer.RingPattern

  test "A ring should extend in both x and z" do
    pattern = RingPattern.new(Color.white, Color.black)

    assert pattern |> pattern_at(point(0, 0, 0)) == Color.white
    assert pattern |> pattern_at(point(1, 0, 0)) == Color.black
    assert pattern |> pattern_at(point(0, 0, 1)) == Color.black
    # 0.708 = just slightly more than √2/2
    assert pattern |> pattern_at(point(0.708, 0, 0.708)) == Color.black
  end
end
