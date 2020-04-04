defmodule RayTracer.Light do
  @moduledoc """
  This module defines light sources
  """

  alias RayTracer.RTuple
  alias RayTracer.Color

  @type t :: %__MODULE__{
    position: RTuple.point,
    intensity: Color.t
  }

  defstruct [:position, :intensity]

  @doc """
  Builds a light source with no size, existing at a single point in space.
  It also has a color intensity.
  """
  @spec point_light(RTuple.point, Color.t) :: t
  def point_light(position, intensity) do
    %__MODULE__{position: position, intensity: intensity}
  end
end
