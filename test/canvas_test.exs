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

  test "Constructing the PPM pixel data" do
    c = Canvas.new(5, 3)
    c1 = Color.new(1.5, 0, 0)
    c2 = Color.new(0, 0.5, 0)
    c3 = Color.new(-0.5, 0, 1)

    r = c
      |> Canvas.write_pixel(0, 0, c1)
      |> Canvas.write_pixel(2, 1, c2)
      |> Canvas.write_pixel(4, 2, c3)
      |> Canvas.to_ppm()


    pd =
      """
      P3
      5 3
      255
      255 0 0 0 0 0 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 128 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 255
      """

    assert r == pd
    assert String.ends_with?(r, "\n") # Must end with a newline
  end

  @tag :skip
  test "Splitting long lines in PPM files" do
    color = Color.new(1, 0.8, 0.6)
    c = Canvas.new(10, 2, color)

    r = c |> Canvas.to_ppm()

    pd =
      """
      P3
      10 2
      255
      255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
      153 255 204 153 255 204 153 255 204 153 255 204 153
      255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
      153 255 204 153 255 204 153 255 204 153 255 204 153
      """

    assert r == pd
    assert String.ends_with?(r, "\n") # Must end with a newline
  end
end
