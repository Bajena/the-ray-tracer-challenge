defmodule RayTracer.Sphere do
  @moduledoc """
  This module defines sphere operations
  """

  alias RayTracer.RTuple

  @type t :: %__MODULE__{
    center: RTuple.point,
    r: number
  }

  defstruct [:center, :r]

  @doc """
  Builds a sphere with given `center` and radius `r`
  """
  @spec new(RTuple.point, number) :: t
  def new(center \\ RTuple.point(0, 0, 0), radius \\ 1) do
    %__MODULE__{center: center, r: radius}
  end
end
