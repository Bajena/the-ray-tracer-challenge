defmodule RayTracer.Canvas do
  @moduledoc """
  This module defines methods for drawing pixels
  """

  alias RayTracer.RTuple
  alias RayTracer.Color

  @type t :: %__MODULE__{
    width: integer,
    height: integer,
    pixels: %{required(tuple()) => RTuple.t}
  }

  defstruct width: 0, height: 0, pixels: %{}

  @spec new(integer, integer) :: t
  def new(width, height) do
    %__MODULE__{width: width, height: height, pixels: build_pixels(width, height)}
  end

  @spec pixel_at(t, integer, integer) :: RTuple.t
  def pixel_at(canvas, x, y), do: canvas.pixels[{x, y}]

  @spec write_pixel(t, integer, integer, RTuple.t) :: t
  def write_pixel(canvas = %__MODULE__{pixels: p}, x, y, color) do
    if x < 0 || x >= canvas.width || y < 0 || y >= canvas.height do
      raise ArgumentError, message: "Position out of bounds: #{x}, #{y}"
    end

    new_pixels = p |> Map.put({x, y}, color)
    %__MODULE__{canvas | pixels: new_pixels}
  end

  defp build_pixels(w, h), do: build_pixels(%{}, 0, 0, w, h)
  defp build_pixels(pixels, _x, y, _w, h) when y >= h, do: pixels
  defp build_pixels(pixels, x, y, w, h) do
    new_x = if x == w - 1, do: 0, else: x + 1
    new_y = if x == w - 1, do: y + 1, else: y
    pixels |>
    Map.put({x, y}, Color.new(0, 0, 0))
    |> build_pixels(new_x, new_y, w, h)
  end
end
