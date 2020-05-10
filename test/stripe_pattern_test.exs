defmodule StripePatternTest do
  alias RayTracer.Color
  alias RayTracer.RTuple
  alias RayTracer.StripePattern
  alias RayTracer.Sphere
  alias RayTracer.Transformations

  import StripePattern, only: [stripe_at: 2, stripe_at_object: 3]
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

    assert p |> stripe_at(point(0, 0, 0)) == Color.white
    assert p |> stripe_at(point(0, 1, 0)) == Color.white
    assert p |> stripe_at(point(0, 2, 0)) == Color.white
  end

  test "A stripe pattern is constant in z" do
    p = StripePattern.new(Color.white, Color.black)

    assert p |> stripe_at(point(0, 0, 0)) == Color.white
    assert p |> stripe_at(point(0, 0, 1)) == Color.white
    assert p |> stripe_at(point(0, 0, 2)) == Color.white
  end

  test "A stripe pattern alternates in x" do
    p = StripePattern.new(Color.white, Color.black)

    assert p |> stripe_at(point(0.9, 0, 0)) == Color.white
    assert p |> stripe_at(point(1, 0, 0)) == Color.black
    assert p |> stripe_at(point(-0.1, 0, 0)) == Color.black
    assert p |> stripe_at(point(-1, 0, 0)) == Color.black
    assert p |> stripe_at(point(-1.1, 0, 0)) == Color.white
  end

  test "Stripes with an object transformation" do
    pattern = StripePattern.new(Color.white, Color.black)
    object = %Sphere{transform: scaling(2, 2, 2)}

    assert pattern |> stripe_at_object(object, point(1.5, 0, 0)) == Color.white
  end

  test "Stripes with both an object and a pattern transformation" do
    pattern = StripePattern.new(Color.white, Color.black, translation(0.5, 0, 0))
    object = %Sphere{transform: scaling(2, 2, 2)}

    assert pattern |> stripe_at_object(object, point(2.5, 0, 0)) == Color.white
  end
end
