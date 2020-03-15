defmodule CanvasTest do
  alias RayTracer.Canvas
  use ExUnit.Case
  doctest RayTracer.Canvas

  test "Creating a canvas" do
    c = Canvas.new(10, 20)

    assert c.width == 10
    assert c.height == 20
  end
end
