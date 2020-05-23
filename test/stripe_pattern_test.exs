defmodule StripePatternTest do
  alias RayTracer.Color
  alias RayTracer.RTuple
  alias RayTracer.StripePattern
  alias RayTracer.Pattern
  alias RayTracer.Sphere
  alias RayTracer.Shape
  alias RayTracer.Transformations

  import Pattern, only: [pattern_at: 2, pattern_at_shape: 3]
  import RTuple, only: [point: 3]
  import Transformations, only: [scaling: 3, translation: 3]

  use ExUnit.Case
  doctest RayTracer.StripePattern

  test "The normal of a plane is constant everywhere" do
    p = StripePattern.new(Color.white, Color.black)

    assert p.a == Color.white
    assert p.b == Color.black
  end

  test "A stripe pattern is constant in y" do
    p = StripePattern.new(Color.white, Color.black)

    assert p |> pattern_at(point(0, 0, 0)) == Color.white
    assert p |> pattern_at(point(0, 1, 0)) == Color.white
    assert p |> pattern_at(point(0, 2, 0)) == Color.white
  end

  test "A stripe pattern is constant in z" do
    p = StripePattern.new(Color.white, Color.black)

    assert p |> pattern_at(point(0, 0, 0)) == Color.white
    assert p |> pattern_at(point(0, 0, 1)) == Color.white
    assert p |> pattern_at(point(0, 0, 2)) == Color.white
  end

  test "A stripe pattern alternates in x" do
    p = StripePattern.new(Color.white, Color.black)

    assert p |> pattern_at(point(0.9, 0, 0)) == Color.white
    assert p |> pattern_at(point(1, 0, 0)) == Color.black
    assert p |> pattern_at(point(-0.1, 0, 0)) == Color.black
    assert p |> pattern_at(point(-1, 0, 0)) == Color.black
    assert p |> pattern_at(point(-1.1, 0, 0)) == Color.white
  end

  test "Stripes with an object transformation" do
    pattern = StripePattern.new(Color.white, Color.black)
    object = %Sphere{} |> Shape.set_transform(scaling(2, 2, 2))

    assert pattern |> pattern_at_shape(object, point(1.5, 0, 0)) == Color.white
  end

  test "Stripes with both an object and a pattern transformation" do
    pattern = StripePattern.new(Color.white, Color.black, translation(0.5, 0, 0))
    object = %Sphere{} |> Shape.set_transform(scaling(2, 2, 2))

    assert pattern |> pattern_at_shape(object, point(2.5, 0, 0)) == Color.white
  end
end
