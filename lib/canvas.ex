defmodule RayTracer.Canvas do
  @moduledoc """
  This module defines methods for drawing pixels
  """

  @type t :: %__MODULE__{
    width: integer,
    height: integer,
    pixels: tuple()
  }

  defstruct width: 0, height: 0, pixels: {}

  @spec new(integer, integer) ::t
  def new(width, height) do
    %__MODULE__{width: width, height: height}
  end
end
