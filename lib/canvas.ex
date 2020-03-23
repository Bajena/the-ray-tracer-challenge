defmodule RayTracer.Canvas do
  @moduledoc """
  This module defines methods for drawing pixels
  """

  alias RayTracer.RTuple
  alias RayTracer.Color
  alias RayTracer.Matrix

  @type t :: %__MODULE__{
    width: integer,
    height: integer,
    pixels: %{required(tuple()) => RTuple.t}
  }

  @ppm_magic_number "P3"
  @ppm_max_color_value 255

  defstruct width: 0, height: 0, pixels: %{}

  @spec new(integer, integer, RTuple.t) :: t
  def new(width, height, color \\ Color.new(0, 0, 0)) do
    pixels = Matrix.new(height, width, color)
    %__MODULE__{width: width, height: height, pixels: pixels}
  end

  @spec pixel_at(t, integer, integer) :: RTuple.t
  def pixel_at(canvas, x, y), do: Matrix.elem(canvas.pixels, y, x)

  @spec write_pixel(t, integer, integer, RTuple.t) :: t
  def write_pixel(canvas = %__MODULE__{width: w, height: h, pixels: p}, x, y, color) do
    if x < 0 || x >= canvas.width || y < 0 || y >= canvas.height do
      raise ArgumentError, message: "Position out of bounds: #{x}, #{y}. Size is #{w},#{h}."
    end

    new_pixels = p |> Matrix.set(y, x, color)

    %__MODULE__{canvas | pixels: new_pixels}
  end

  def to_ppm(%RayTracer.Canvas{width: width, height: height, pixels: pixels}) do
    pd =
      pixels
      |> Enum.map(&row_to_ppm/1)
      |> Enum.join("\n")

    "#{@ppm_magic_number}\n#{width} #{height}\n#{@ppm_max_color_value}\n#{pd}\n"
  end

  defp row_to_ppm(row) do
    row
    |> Enum.map(&color_to_ppm/1)
    |> Enum.join(" ")
  end

  defp color_to_ppm(color) do
   color
   |> Color.scale(@ppm_max_color_value)
   |> Color.map(fn (v) -> v |> round() |> to_string() end)
   |> Enum.join(" ")
  end
end
