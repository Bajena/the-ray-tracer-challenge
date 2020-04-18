defmodule RayTracer.Transformations do
  @moduledoc """
  This module defines matrix transformations like
  scaling, shearing, rotating and translating
  """
  alias RayTracer.Matrix
  alias RayTracer.RTuple

  @spec translation(number, number, number) :: Matrix.matrix
  def translation(x, y, z) do
    Matrix.ident
    |> Matrix.set(0, 3, x)
    |> Matrix.set(1, 3, y)
    |> Matrix.set(2, 3, z)
  end

  @spec scaling(number, number, number) :: Matrix.matrix
  def scaling(x, y, z) do
    Matrix.ident
    |> Matrix.set(0, 0, x)
    |> Matrix.set(1, 1, y)
    |> Matrix.set(2, 2, z)
  end

  @doc """
    Returns a matrix that is a `r` radians rotation matrix over the X axis.
    """
  @spec rotation_x(number) :: Matrix.matrix
  def rotation_x(r) do
    Matrix.ident
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
    Matrix.ident
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
    Matrix.ident
    |> Matrix.set(0, 0, :math.cos(r))
    |> Matrix.set(0, 1, -:math.sin(r))
    |> Matrix.set(1, 0, :math.sin(r))
    |> Matrix.set(1, 1, :math.cos(r))
  end

  @doc """
    Returns a shearing matrix in which:
    - xy - moves x in proportion to y
    - xz - moves x in proportion to z
    - yx - moves y in proportion to x
    - yz - moves y in proportion to z
    - zx - moves z in proportion to x
    - zy - moves z in proportion to y
    """
  @spec shearing(number, number, number, number, number, number) :: Matrix.matrix
  def shearing(xy, xz, yx, yz, zx, zy) do
    Matrix.ident
    |> Matrix.set(0, 1, xy)
    |> Matrix.set(0, 2, xz)
    |> Matrix.set(1, 0, yx)
    |> Matrix.set(1, 2, yz)
    |> Matrix.set(2, 0, zx)
    |> Matrix.set(2, 1, zy)
  end

  @doc """
    Returns a transormation matrix which allows to "pretend" that the eye moves instead of the world.
    `from` - Specifies where we want the eye to be in the scene
    `to` - Specifies the point at which the eye will look
    `up` - A vector indicating which direction is up.
    """
  @spec view_transform(RTuple.point, RTuple.point, RTuple.vector) :: Matrix.matrix
  def view_transform(from, to, up) do
    nup = up |> RTuple.normalize
    forward = RTuple.sub(to, from) |> RTuple.normalize
    left = RTuple.cross(forward, nup)

    true_up = RTuple.cross(left, forward)

    orientation =
      Matrix.ident
      |> Matrix.set(0, 0, left |> RTuple.x)
      |> Matrix.set(0, 1, left |> RTuple.y)
      |> Matrix.set(0, 2, left |> RTuple.z)
      |> Matrix.set(1, 0, true_up |> RTuple.x)
      |> Matrix.set(1, 1, true_up |> RTuple.y)
      |> Matrix.set(1, 2, true_up |> RTuple.z)
      |> Matrix.set(2, 0, -(forward |> RTuple.x))
      |> Matrix.set(2, 1, -(forward |> RTuple.y))
      |> Matrix.set(2, 2, -(forward |> RTuple.z))

    translate_from = translation(
      -(from |> RTuple.x),
      -(from |> RTuple.y),
      -(from |> RTuple.z)
    )

    orientation |> Matrix.mult(translate_from)
  end
end
