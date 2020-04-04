defmodule LightTest do
  alias RayTracer.Color
  alias RayTracer.RTuple
  alias RayTracer.Light

  use ExUnit.Case
  doctest RayTracer.Light

  import Light, only: [point_light: 2]
  import RTuple, only: [point: 3]

  test "A point light has a position and intensity" do
    intensity = Color.new(1, 1, 1)
    position = point(0, 0, 0)
    light = point_light(position, intensity)

    assert light.position == position
    assert light.intensity == intensity
  end
end
