defmodule ColorTest do
  alias RayTracer.Color
  use ExUnit.Case
  doctest RayTracer.Color

  import RayTracer.RTuple.CustomOperators

  test "Colors are (red, green, blue) tuples" do
    c = Color.new(-0.5, 0.4, 1.7)

    assert Color.red(c) == -0.5
    assert Color.green(c) == 0.4
    assert Color.blue(c) == 1.7
  end

  test "Adding colors" do
    c1 = Color.new(0.9, 0.6, 0.75)
    c2 = Color.new(0.7, 0.1, 0.25)

    assert Color.add(c1, c2) <~> Color.new(1.6, 0.7, 1.0)
  end

  test "Subtracting colors" do
    c1 = Color.new(0.9, 0.6, 0.75)
    c2 = Color.new(0.7, 0.1, 0.25)

    assert Color.sub(c1, c2) <~> Color.new(0.2, 0.5, 0.5)
  end

  test "Multiplying a color by a scalar" do
    c1 = Color.new(0.2, 0.3, 0.4)

    assert Color.mul(c1, 2) <~> Color.new(0.4, 0.6, 0.8)
  end

  test "Multiplying colors" do
    c1 = Color.new(1, 0.2, 0.4)
    c2 = Color.new(0.9, 1, 0.1)

    assert Color.hadamard_product(c1, c2) <~> Color.new(0.9, 0.2, 0.04)
  end
end
