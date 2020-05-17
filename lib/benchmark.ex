defmodule Benchmark do
  @moduledoc """
  This module is a utility for calculating computation time of a given funciton
  """

  def measure(function) do
    function
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000_000)
  end
end
