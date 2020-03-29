defmodule RayTracer.Ray do
  @moduledoc """
  This module defines rays and ray operations
  """

  alias RayTracer.RTuple

  @type t :: %__MODULE__{
    origin: RTuple.t,
    direction: RTuple.t
  }

  defstruct [:origin, :direction]

  @spec new(RTuple.t, RTuple.t) :: t
  def new(origin, direction) do
    %RayTracer.Ray{origin: origin, direction: direction}
  end
end
