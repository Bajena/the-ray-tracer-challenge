defmodule RayTracer.Sphere do
  @moduledoc """
  This module defines sphere operations
  """

  alias RayTracer.RTuple
  alias RayTracer.Matrix

  @type t :: %__MODULE__{
    center: RTuple.point,
    r: number,
    transform: Matrix.matrix
  }

  defstruct [:center, :r, :transform]

  @doc """
  Builds a sphere with given `center`, radius `r` and transformation matrix
  """
  @spec new(RTuple.point, number) :: t
  def new(center \\ RTuple.point(0, 0, 0), radius \\ 1, transform \\ Matrix.ident(4)) do
    %__MODULE__{center: center, r: radius, transform: transform}
  end

  @spec new(t, Matrix.matrix) :: t
  def set_transform(s, t) do
    %__MODULE__{s | transform: t}
  end
end
