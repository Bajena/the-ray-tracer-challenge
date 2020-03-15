defmodule RayTracer.Canvas do
  @moduledoc """
  This module defines methods for drawing pixels
  """

  defstruct width: 0, height: 0, pixels: {}

  def new(width, height) do
    %{width: width, height: height}
  end


end
