defmodule TransformationsTest do
  alias RayTracer.Matrix
  alias RayTracer.RTuple
  import RayTracer.Transformations

  use ExUnit.Case
  doctest RayTracer.Transformations

  test "Multiplying by a translation matrix" do
    t = translation(5, -3, 2)
    p = RTuple.point(-3, 4, 5)

    assert t |> Matrix.mult(p) == RTuple.point(2, 1, 7)
  end
end
