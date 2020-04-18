defmodule RayTracer.Camera do
  @moduledoc """
  This module defines a camera which maps the three-dimensional scene onto a
  two-dimensional canvas.
  Camera's canvas will always be exactly one unit in front of the camera. This makes
  the math a bit cleaner.
  """

  alias RayTracer.Matrix

  @type t :: %__MODULE__{
    hsize: integer,
    vsize: integer,
    field_of_view: number,
    transform: Matrix.matrix,
    half_width: number,
    half_height: number,
    pixel_size: number
  }

  defstruct [
    :hsize, :vsize, :field_of_view, :transform, :half_width, :half_height, :pixel_size
  ]

  @doc """
  Returns a new camera
  `hsize` - horizontal size (in pixels) of the canvas that the picture will be rendered to
  `vsize` - vertical size
  `field_of_view` - angle that describes how much the camera can see.
                    When the field of view is small, the view will be "zoomed in",
                    magnifying a smaller area of the scene.
  `transform` - matrix describing how the world should be oriented relative to the
                camera. This is usually a view transformation matrix.
  """
  @spec new(integer, integer, number, Matrix.matrix) :: t
  def new(hsize, vsize, field_of_view, transform \\ Matrix.ident) do
    values = %__MODULE__{
      hsize: hsize,
      vsize: vsize,
      field_of_view: field_of_view,
      transform: transform
    } |> Map.merge(compute_sizes(hsize, vsize, field_of_view))
  end

  # Computes:
  # `pixel_size` - the size (in world-space units) of the pixels on the canvas.
  # `half_height` - half of the canvas height in world units
  # `half_width` - half of the canvas width in world units
  @spec compute_sizes(number, number, number) :: map
  defp compute_sizes(hsize, vsize, field_of_view) do
    half_view = :math.tan(field_of_view / 2)

    aspect = hsize / vsize

    sizes = if aspect >= 1 do
              %{half_width: half_view, half_height: half_view / aspect}
            else
              %{half_width: half_view * aspect, half_height: half_view}
            end

    %{pixel_size: sizes.half_width * 2 / hsize} |> Map.merge(sizes)
  end
end
