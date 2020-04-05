defmodule RayTracer.Material do
  @moduledoc """
  This module defines materials
  """

  alias RayTracer.Color

  @type t :: %__MODULE__{
    color: Color.t,
    ambient: number,
    diffuse: number,
    specular: number,
    shininess: number
  }

  defstruct [
    color: Color.white, ambient: 0.1, diffuse: 0.9, specular: 0.9, shininess: 200
  ]

  @doc """
  Builds a new material.
  For ambient, diffuse and specular the typical values are between 0 and 1.
  For shininess values between 10 (very large highlight) and 200 (very small highlight)
  seem to work best.
  """
  @spec new(Color.t, number, number, number, number) :: t
  def new(color \\ Color.white, ambient \\ 0.1, diffuse \\ 0.9, specular \\ 0.9, shininess \\ 200) do
    %__MODULE__{
      color: color,
      ambient: ambient,
      diffuse: diffuse,
      specular: specular,
      shininess: shininess
    }
  end
end
