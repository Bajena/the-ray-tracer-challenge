defmodule MaterialTest do
  alias RayTracer.Color
  alias RayTracer.Material

  use ExUnit.Case
  doctest RayTracer.Material

  test "The default material" do
    m = Material.new

    assert m.color == Color.new(1, 1, 1)
    assert m.ambient == 0.1
    assert m.diffuse == 0.9
    assert m.specular == 0.9
    assert m.shininess == 200.0
  end
end
