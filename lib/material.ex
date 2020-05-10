defmodule RayTracer.Material do
  @moduledoc """
  This module defines materials
  """

  alias RayTracer.Color
  alias RayTracer.StripePattern

  @type t :: %__MODULE__{
    color: Color.t,
    pattern: StripePattern.t | nil,
    ambient: number,
    diffuse: number,
    specular: number,
    shininess: number
  }

  defstruct [
    color: Color.white, pattern: nil, ambient: 0.1, diffuse: 0.9, specular: 0.9, shininess: 200
  ]

  @doc """
  Builds a new material with default attributes
  """
  @spec new :: t
  def new do
    %__MODULE__{}
  end
end
