defmodule RayTracer.Camera do
  @moduledoc """
  This module defines a camera which maps the three-dimensional scene onto a
  two-dimensional canvas.
  Camera's canvas will always be exactly one unit in front of the camera. This makes
  the math a bit cleaner.
  """

  alias RayTracer.Matrix
  alias RayTracer.Ray
  alias RayTracer.RTuple
  alias RayTracer.World
  alias RayTracer.Canvas

  import RTuple, only: [point: 3]

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
    %__MODULE__{
      hsize: hsize,
      vsize: vsize,
      field_of_view: field_of_view,
      transform: transform
    } |> Map.merge(compute_sizes(hsize, vsize, field_of_view))
  end

  @doc """
  Renders the provided world on a canvas defined by camera's properties
  """
  @spec render(t, World.t) :: Canvas.t
  def render(camera, world) do
    Enum.reduce(0..(camera.vsize - 1), Canvas.new(camera.hsize, camera.vsize), fn y, canvas ->
      if rem(y, 10) == 0, do: IO.puts("#{y}/#{camera.vsize}")

      0..(camera.hsize - 1)
      |> Flow.from_enumerable()
      |> Flow.partition()
      |> Flow.map(&compute_pixel(world, camera, &1, y))
      |> Enum.reduce(canvas, fn r, canvas ->
        canvas |> Canvas.write_pixel(r.x, y, r.color)
      end)
    end)
  end

  @doc """
  Computes the world coordinates at the center of the given pixel and then constructs
  a ray that passes through that point.
  `px` - x position of the pixel
  `py` - y position of the pixel
  """
  @spec ray_for_pixel(t, number, number) :: Ray.t
  def ray_for_pixel(camera, px, py) do
    # The offset from the edge of the canvas to the pixel's center
    x_offset = (px + 0.5) * camera.pixel_size
    y_offset = (py + 0.5) * camera.pixel_size

    # The untransformed coordinates of the pixel in world space.
    # Remember that the camera looks toward -z, so +x is to the left.
    world_x = camera.half_width - x_offset
    world_y = camera.half_height - y_offset

    # Using the camera matrix transform the canvas point and the origin.
    # Then compute the ray's direction vector.
    # Remember that the canvas is at z = -1
    invct = Matrix.inverse(camera.transform)
    world_point = point(world_x, world_y, -1)
    pixel = invct |> Matrix.mult(world_point)
    origin = invct |> Matrix.mult(point(0, 0, 0))
    direction = RTuple.sub(pixel, origin) |> RTuple.normalize

    Ray.new(origin, direction)
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

  defp compute_pixel(world, camera, x, y) do
    ray = ray_for_pixel(camera, x, y)
    %{x: x, color: World.color_at(world, ray)}
  end
end
