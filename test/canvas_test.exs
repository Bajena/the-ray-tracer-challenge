defmodule CanvasTest do
  alias RayTracer.Canvas
  alias RayTracer.Color
  use ExUnit.Case
  doctest RayTracer.Canvas

  test "Creating a canvas" do
    c = Canvas.new(10, 20)

    assert c.width == 10
    assert c.height == 20
    assert Canvas.pixel_at(c, 0, 0) == Color.new(0, 0, 0)
  end

  test "Writing pixels" do
    c = Canvas.new(10, 20)
    red = Color.new(1, 0, 0)

    assert c |> Canvas.write_pixel(2, 3, red) |> Canvas.pixel_at(2, 3) == red
  end
end
