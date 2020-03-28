defmodule RayTracer.Transformations do
  @moduledoc """
  This module defines matrix transformations like
  scaling, shearing, rotating and translating
  """
  alias RayTracer.Matrix

  @spec translation(number, number, number) :: Matrix.matrix
  def translation(x, y, z) do
    Matrix.ident(4)
    |> Matrix.set(0, 3, x)
    |> Matrix.set(1, 3, y)
    |> Matrix.set(2, 3, z)
  end

  @spec scaling(number, number, number) :: Matrix.matrix
  def scaling(x, y, z) do
    Matrix.ident(4)
    |> Matrix.set(0, 0, x)
    |> Matrix.set(1, 1, y)
    |> Matrix.set(2, 2, z)
  end

  @doc """
    Returns a matrix that is a `r` radians rotation matrix over the X axis.
    """
  @spec rotation_x(number) :: Matrix.matrix
  def rotation_x(r) do
    Matrix.ident(4)
    |> Matrix.set(1, 1, :math.cos(r))
    |> Matrix.set(1, 2, -:math.sin(r))
    |> Matrix.set(2, 1, :math.sin(r))
    |> Matrix.set(2, 2, :math.cos(r))
  end

  @doc """
    Returns a matrix that is a `r` radians rotation matrix over the Y axis.
    """
  @spec rotation_y(number) :: Matrix.matrix
  def rotation_y(r) do
    Matrix.ident(4)
    |> Matrix.set(0, 0, :math.cos(r))
    |> Matrix.set(0, 2, :math.sin(r))
    |> Matrix.set(2, 0, -:math.sin(r))
    |> Matrix.set(2, 2, :math.cos(r))
  end

  @doc """
    Returns a matrix that is a `r` radians rotation matrix over the Z axis.
    """
  @spec rotation_z(number) :: Matrix.matrix
  def rotation_z(r) do
    Matrix.ident(4)
    |> Matrix.set(0, 0, :math.cos(r))
    |> Matrix.set(0, 1, -:math.sin(r))
    |> Matrix.set(1, 0, :math.sin(r))
    |> Matrix.set(1, 1, :math.cos(r))
  end
end
