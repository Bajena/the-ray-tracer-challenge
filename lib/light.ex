defmodule RayTracer.Light do
  @moduledoc """
  This module defines light sources
  """

  alias RayTracer.RTuple
  alias RayTracer.Color
  alias RayTracer.Material
  alias RayTracer.Pattern
  alias RayTracer.Shape

  import RTuple, only: [normalize: 1, reflect: 2]

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

  @doc """
  Computes a resulting color after applying the Phong shading model.
  `material` - material definition for the illuminated object.
  `position` - point being iluminated
  `light` - light source
  `eyev` - eye vector
  `normalv` - surface normal vector
  `in_shadow` - indicates whether the point is in shadow of an object
  """
  @spec lighting(Material.t, Shape.t, t, RTuple.point, RTuple.vector, RTuple.vector, boolean) :: Color.t
  def lighting(material, object, light, position, eyev, normalv, in_shadow) do
    # Combine the surface color with the light's color/intensity
    effective_color =
      material
      |> material_color_at(object, position)
      |> Color.hadamard_product(light.intensity)

    # Find the direction to the light sourc
    lightv = light.position |> RTuple.sub(position) |> normalize

    # Compute the ambient contribution
    ambient = effective_color |> Color.mul(material.ambient)

    if in_shadow do
      ambient
    else
      # `light_dot_normal` represents the cosine of the angle between the
      # light vector and the normal vector. A negative number means the
      # light is on the other side of the surface.
      light_dot_normal = RTuple.dot(lightv, normalv)

      diffuse = calc_diffuse(light_dot_normal, effective_color, material)
      specular = calc_specular(light_dot_normal, lightv, normalv, eyev, material, light)

      ambient |> Color.add(diffuse) |> Color.add(specular)
    end
  end

  defp material_color_at(material, object, point) do
    if material.pattern do
      material.pattern |> Pattern.pattern_at_shape(object, point)
    else
      material.color
    end
  end

  defp calc_diffuse(light_dot_normal, _, _) when light_dot_normal < 0, do: Color.black
  defp calc_diffuse(light_dot_normal, effective_color, material) do
    effective_color |> Color.mul(material.diffuse * light_dot_normal)
  end

  defp calc_specular(light_dot_normal, _, _, _, _, _) when light_dot_normal < 0, do: Color.black
  defp calc_specular(_, lightv, normalv, eyev, material, light) do
    # `reflect_dot_eye` represents the cosine of the angle between the
    # reflection vector and the eye vector. A negative number means the
    # light reflects away from the eye.
    reflectv = lightv |> RTuple.negate() |> reflect(normalv)
    reflect_dot_eye = reflectv |> RTuple.dot(eyev)

    if reflect_dot_eye <= 0 do
      Color.black
    else
      # compute the specular contribution
      factor = :math.pow(reflect_dot_eye, material.shininess)
      light.intensity |> Color.mul(material.specular * factor)
    end
  end
end
