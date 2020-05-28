defmodule RayTracer.General do
  @moduledoc """
  This module contains general utilty functions
  """

  @doc """
  Rounds a number to fifth decimal number
  """
  @spec round_eps(number) :: number
  def round_eps(number) do
    number
    |> :erlang.float
    |> Float.round(5)
  end
end
