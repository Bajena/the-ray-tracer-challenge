defmodule RayTracer.PerturbPattern do
  @moduledoc """
  This module defines a pattern which perturbs the input pattern using
  Perlin noise
  """

  alias RayTracer.Color
  alias RayTracer.Matrix
  alias RayTracer.RTuple
  alias RayTracer.Pattern

  @type t :: %__MODULE__{
    perturbed_pattern: Pattern.t,
    transform: Matrix.matrix
  }

  use Pattern, [:perturbed_pattern]

  defimpl Pattern.CombinationProtocol do
    alias RayTracer.Color
    alias RayTracer.Shape
    alias RayTracer.Matrix
    alias RayTracer.RTuple
    alias RayTracer.Pattern
    alias RayTracer.PerturbedPattern.SimplexNoiseImproved

    @spec pattern_at_shape(Pattern.t, Shape.t, RTuple.point) :: Color.t
    def pattern_at_shape(pattern, object, position) do
      scale = 0.3
      pscale = 0.7
      x = RTuple.x(position) * pscale
      y = RTuple.y(position) * pscale
      z = RTuple.z(position) * pscale

      noisex = SimplexNoiseImproved.noise(x, y,z) * scale

      noisey = SimplexNoiseImproved.noise(x, y, z + 1) * scale

      noisez = SimplexNoiseImproved.noise(x, y, z + 2) * scale

      npoint = RTuple.point(noisex, noisey, noisez)
      Pattern.pattern_at_shape(pattern.perturbed_pattern, object, position |> RTuple.add(npoint))
    end
  end
end
