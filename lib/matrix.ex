defmodule RayTracer.Matrix do
  alias RayTracer.RTuple

  @moduledoc """
  *Matrix* is a linear algebra library for manipulating dense matrices. Its
  primary design goal is ease of use.  It is desirable that the *Matrix* package
  interact with standard Elixir language constructs and other packages.  The
  underlying storage mechanism is, therefore, Elixir lists.
  A secondary design consideration is for the module to be reasonably efficient
  in terms of both memory usage and computations.  Unfortunately there is a
  trade off between memory efficiency and computational efficiency.  Where these
  requirements conflict *Matrix* will use the more computationally efficient
  algorithm.
  Each matrix is represented as a "list of lists" whereby a 3x4 matrix is
  represented by a list of three items, with each item a list of 4 values.
  Constructors are provided for several common matrix configurations including
  zero filled, one filled, random filled the identity matrix, etc.
  ## Examples
      iex> Matrix.new(3, 4)
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
      iex> Matrix.ident(4)
      [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]
  """
  @typedoc """
      A list of values representing a matrix row.
  """
  @type row :: [number]
  @type matrix :: [row]

  @comparison_epsilon 1.0e-5
  @comparison_max_ulp 1


  @doc """
    Returns a new matrix of the specified size (number of rows and columns).
    All elements of the matrix are filled with the supplied value "val"
    (default 0).
    #### See also
    [ones/2](#ones/2), [rand/2](#rand/2), [zeros/2](#zeros/2)
    #### Examples
        iex> Matrix.new(3, 4)
        [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
        iex> Matrix.new(2, 3, -10)
        [[-10, -10, -10], [-10, -10, -10]]
    """
  @spec new(integer, integer, number) :: matrix
  def new(rows, cols, val \\ 0) do
    for _r <- 1..rows, do: make_row(cols,val)
  end

  def make_row(0, _val), do: []
  def make_row(n, val), do: [val] ++ make_row(n-1, val)

  @spec from_string(String.t) :: matrix
  def from_string(string) do
    string
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(fn(r) -> String.length(r) == 0 end)
    |> Enum.map(fn(r) -> parse_row(r) end)
  end

  def parse_row(row_string) do
    row_string
    |> String.split("|")
    |> Enum.map(fn(v) -> v |> String.trim |> Float.parse end)
    |> Enum.filter(fn(v) -> v != :error end)
    |> Enum.map(fn(v) -> v |> Kernel.elem(0) end)
  end

  @doc """
    Returns a new matrix of the specified size (number of rows and columns).
    All elements of the matrix are filled with the zeros.
    #### See also
    [new/3](#new/3), [ones/2](#ones/2), [rand/2](#rand/2)
    #### Examples
        iex> Matrix.zeros(3, 4)
        [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
    """
  @spec zeros(integer, integer) :: matrix
  def zeros(rows, cols), do: new(rows, cols, 0)


  @doc """
    Returns a new matrix of the specified size (number of rows and columns).
    All elements of the matrix are filled with the ones.
    #### See also
    [new/3](#new/3), [rand/2](#rand/2), [zeros/2](#zeros/2)
    #### Examples
        iex> Matrix.ones(3, 4)
        [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]]
    """
  @spec ones(integer, integer) :: matrix
  def ones(rows, cols), do: new(rows, cols, 1)


  @doc """
    Returns a new square "diagonal" matrix whose elements are zero except for
    the diagonal.  The diagonal elements will be composed of the supplied list
    #### See also
    [new/3](#new/3), [ones/2](#ones/2), [ident/1](#ident/1)
    #### Examples
        iex> Matrix.diag([1,2,3])
        [[1, 0, 0], [0, 2, 0], [0, 0, 3]]
    """
  @spec diag([number]) :: matrix
  def diag(d) do
    rows = length(d)
    Enum.zip( d, 0..rows-1 )
    |> Enum.map(fn({v,s})->
                  row = [v]++make_row(rows-1,0)
                  rrotate(row, s)
                end)
  end
  def lrotate(list, 0), do: list
  def lrotate([head|list], number), do: lrotate(list ++ [head], number - 1)
  def rrotate(list, number), do:
    list
    |> Enum.reverse
    |> lrotate(number)
    |> Enum.reverse


  @doc """
    Returns a new "identity" matrix of the specified size.  The identity is
    defined as a square matrix with ones on the diagonal and zeros in all
    off-diagonal elements.  Since the matrix is square only a single size
    parameter is required.
    #### See also
    [diag/1](#diag/1), [ones/2](#ones/2), [rand/2](#rand/2)
    #### Examples
        iex> Matrix.ident(3)
        [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
    """
  @spec ident(integer) :: matrix
  def ident(rows), do: diag(make_row(rows,1))



  @doc """
    Returns the size (dimensions) of the supplied matrix.  The return value is a
    tuple of the dimensions of the matrix as {rows,cols}.
    #### See also
    [new/3](#new/3), [ones/2](#ones/2), [rand/2](#rand/2)
    #### Examples
        iex> Matrix.size( Matrix.new(3,4) )
        {3, 4}
    """
  @spec size(matrix) :: {integer,integer}
  def size(x) do
    rows = length(x)
    cols = length( List.first(x) )
    {rows, cols}
  end


  @doc """
    Returns a matrix that is a copy of the supplied matrix (x) with the
    specified element (row and column) set to the specified value (val).  The
    row and column indices are zero-based.  Negative indices indicate an offset
    from the end of the row or column. If an index is out of bounds, the
    original matrix is returned.
    #### See also
    [elem/3](#elem/3)
    #### Examples
        iex> Matrix.set( Matrix.ident(3), 0,0, -1)
        [[-1, 0, 0], [0, 1, 0], [0, 0, 1]]
    """
  @spec set(matrix, integer, integer, number) :: matrix
  def set(x, row, col, val) do
    row_vals = Enum.at(x,row)
    new_row = List.replace_at(row_vals,col,val)
    List.replace_at(x, row, new_row)
  end


  @doc """
    Returns the value of the specified element (row and column) of the given
    matrix (x).  The row and column indices are zero-based.  Returns `default`
    if either row or col are out of bounds.
    #### See also
    [set/4](#set/4)
    #### Examples
        iex> Matrix.elem( Matrix.ident(3), 0,0 )
        1
    """
  @spec elem(matrix, integer, integer) :: number
  def elem(x, row, col, default \\ nil) do
    row_vals = Enum.at(x,row,nil)
    if row_vals == nil, do: default, else: Enum.at(row_vals, col, default)
  end


  @doc """
    Returns a cofactor of a matrix at given row, col
    """
  @spec cofactor(matrix, integer, integer) :: number
  def cofactor(m, row, col) do
    min = minor(m, row, col)

    case rem(row  + col, 2) do
      0 -> min
      1 -> -min
    end
  end

  @doc """
    Returns a minor of a matrix at given row,col
    """
  @spec minor(matrix, integer, integer) :: number
  def minor(m, row, col) do
    m
    |> submatrix(row, col)
    |> det
  end

  @doc """
    Returns the matrix with given row and column removed
    """
  @spec submatrix(matrix, integer, integer) :: matrix
  def submatrix(m, row, col) do
    m
    |> List.delete_at(row)
    |> Enum.map(&(List.delete_at(&1, col)))
  end


  @doc """
    Computes a determinant of matrix
    """
  @spec det(matrix) :: number
  def det(m) do
    {s,_} = size(m)

    case s do
      2 ->
        a = m |> elem(0,0)
        b = m |> elem(0,1)
        c = m |> elem(1,0)
        d = m |> elem(1,1)

        a * d - b * c
      _ ->
        for col <- 0..(s-1) do
          elem(m, 0, col) * cofactor(m, 0, col)
        end |> Enum.sum
    end
  end

  @doc """
    Checks if a matrix is invertible
    """
  @spec invertible?(matrix) :: boolean
  def invertible?(m), do: det(m) != 0


  @doc """
    Calculates an inverse of matrix
    """
  @spec inverse(matrix) :: matrix
  def inverse(m) do
    d = det(m)

    {rows,cols} = size(m)
    cofactors =
      for row <- 0..(rows - 1), do:
        for col <- 0..(cols - 1), do:
          cofactor(m, row, col)

    cofactors
    |> transpose
    |> scale(1 / d)
  end


  @doc """
    Returns a new matrix whose elements are the sum of the elements of
    the provided matrices.  If the matrices are of differing sizes, the
    returned matrix will be the size and dimensions of the "overlap" between
    them.  For instance, the sum of a 3x3 matrix with a 2x2 matrix will be
    2x2.  The sum of a 3x1 matrix with a 1x3 matrix will be 1x1.
    #### See also
    [sub/2](#sub/2), [emult/2](#emult/2)
    #### Examples
        iex> Matrix.add( Matrix.ident(3), Matrix.ident(3) )
        [[2, 0, 0], [0, 2, 0], [0, 0, 2]]
        iex> Matrix.add( Matrix.ones(3,3), Matrix.ones(2,2) )
        [[2, 2], [2, 2]]
        iex> Matrix.add( Matrix.ones(3,1), Matrix.ones(1,3) )
        [[2]]
    """
  @spec add(matrix, matrix) :: matrix
  def add(x, y) do
    Enum.zip(x, y) |> Enum.map( fn({a,b})->add_rows(a,b) end )
  end


  @doc """
    Returns a new matrix whose elements are the difference (subtraction) of the
    elements of the provided matrices.  If the matrices are of differing sizes,
    the returned matrix will be the size and dimensions of the "overlap" between
    them.  For instance, the difference of a 3x3 matrix with a 2x2 matrix will
    be 2x2. The difference of a 3x1 matrix with a 1x3 matrix will be 1x1.
    #### See also
    [add/2](#add/2), [emult/2](#emult/2)
    #### Examples
        iex> Matrix.sub( Matrix.ident(3), Matrix.ones(3,3) )
        [[0, -1, -1], [-1, 0, -1], [-1, -1, 0]]
        iex> Matrix.sub( Matrix.ones(3,3), Matrix.ones(2,2) )
        [[0, 0], [0, 0]]
        iex> Matrix.sub( Matrix.ones(3,1), Matrix.ones(1,3) )
        [[0]]
    """
  @spec sub(matrix, matrix) :: matrix
  def sub(x, y) do
    Enum.zip(x, y) |> Enum.map( fn({a,b})->subtract_rows(a,b) end )
  end

  @spec from_r_tuple(RTuple.t) :: matrix
  def from_r_tuple(%RayTracer.RTuple{values: values}) do
    values
    |> Tuple.to_list
    |> Enum.map(&(make_row(1, &1)))
  end

  @doc """
    Returns a new matrix which is a multiplication of a matrix `x` and a vector
    (tuple) `t`.
    """
  @spec mult(matrix, RTuple.t) :: RTuple.t
  def mult(x, t = %RayTracer.RTuple{}) do
    mult(x, from_r_tuple(t)) |> Enum.map(&Enum.at(&1, 0)) |> RTuple.new
  end

  @doc """
    Returns a new matrix which is the linear algebra matrix multiply
    of the provided matrices.  It is required that the number of columns
    of the first matrix (x) be equal to the number of rows of the second
    matrix (y).  If x is an NxM and y is an MxP, the returned matrix product
    xy is NxP.  If the number of columns of x does not equal the number of
    rows of y an `ArgumentError` exception is thrown with the message "sizes
    incompatible"
    """
  @spec mult(matrix, matrix) :: matrix
  def mult(x, y) do

    {_rx,cx} = size(x)
    {ry,_cy} = size(y)
    if (cx != ry), do:
      raise ArgumentError, message: "sizes incompatible"

    trans_y = transpose(y)
    Enum.map(x, fn(row)->
                      Enum.map(trans_y, &dot_product(row, &1))
                    end)
  end

  defp dot_product(r1, _r2) when r1 == [], do: 0
  defp dot_product(r1, r2) do
    [h1|t1] = r1
    [h2|t2] = r2
    (h1*h2) + dot_product(t1, t2)
  end



  @doc """
    Returns a new matrix whose elements are the transpose of the supplied matrix.
    The transpose essentially swaps rows for columns - that is, the first row
    becomes the first column, the second row becomes the second column, etc.
  """
  @spec transpose(matrix) :: matrix
  def transpose(m) do
    swap_rows_cols(m)
  end

  defp swap_rows_cols( [h|_t] ) when h==[], do: []
  defp swap_rows_cols(rows) do
    firsts = Enum.map(rows, fn(x) -> hd(x) end) # first element of each row
    rest = Enum.map(rows, fn(x) -> tl(x) end)   # remaining elements of each row
    [firsts | swap_rows_cols(rest)]
  end


  @doc """
  Compares two matrices as being (approximately) equal.  Since floating point
  numbers have slightly different representations and accuracies on different
  architectures it is generally not a good idea to compare them directly.
  Rather numbers are considered equal if they are within an "epsilon" of each
  other.  *almost_equal?* compares all elements of two matrices, returning true
  if all elements are within the provided epsilon.
  #### Examples
      iex> Matrix.almost_equal?( [[1, 0], [0, 1]], [[1,0], [0,1+1.0e-5]] )
      false
      iex> Matrix.almost_equal?( [[1, 0], [0, 1]], [[1,0], [0,1+0.5e-5]] )
      true
  """
  @spec almost_equal?(matrix, matrix, number, number) :: boolean
  def almost_equal?(x, y, eps \\ @comparison_epsilon, max_ulp \\ @comparison_max_ulp) do
    Enum.zip(x,y)
    |> Enum.map(fn({r1,r2})->rows_almost_equal?(r1, r2, eps, max_ulp) end)
    |> Enum.all?
  end


  @doc """
  Returns a new matrix whose elements are the elements of matrix x multiplied by
  the scale factor "s".
  #### Examples
      iex> Matrix.scale( Matrix.ident(3), 2 )
      [[2,0,0], [0,2,0], [0,0,2]]
      iex> Matrix.scale( Matrix.ones(3,4), -2 )
      [[-2, -2, -2, -2], [-2, -2, -2, -2], [-2, -2, -2, -2]]
  """
  @spec scale(matrix, number) :: matrix
  def scale(x, s) do
    Enum.map(x, fn(r)->scale_row(r,s) end)
  end


  #################
  # Private supporting functions
  #################

  #
  # These functions apply a specific math operation to all the elements of the
  # supplied rows.  They are used by the math routine (e.g., add).  They call the
  # recursive element adding functions to continually append new elements to
  # the row.  Note that this was found to be faster than a simple list
  # comprehension or Enum.map, at least using Erlang/OTP 18 and Elixir 1.1.1
  #
  defp add_rows(r1, r2) when r1 == []  or  r2 == [], do: []
  defp add_rows(r1, r2) do
    [h1|t1] = r1
    [h2|t2] = r2
    [h1+h2] ++ add_rows(t1,t2)
  end

  defp subtract_rows(r1, r2) when r1 == []  or  r2 == [], do: []
  defp subtract_rows(r1, r2) do
    [h1|t1] = r1
    [h2|t2] = r2
    [h1-h2] ++ subtract_rows(t1,t2)
  end

  #
  # Multiplies a row by a (scalar) constant.
  #
  defp scale_row(r, v) do
    Enum.map(r, fn(x) -> x * v end)
  end

  #
  # The following functions are used for floating point comparison of matrices.
  #
  # Compares two rows as being (approximately) equal.
  defp rows_almost_equal?(r1, r2, eps, max_ulp) do
    x = Enum.zip(r1,r2)
        |> Enum.map(fn({x,y})->close_enough?(x, y, eps, max_ulp) end)
    Enum.all?(x)
  end

  @doc """
  Code borrowed from the ExMath library and duplicated here to reduce
  dependencies.  ExMath is copyright © 2015 Ookami Kenrou <ookamikenrou@gmail.com>
  Equality comparison for floating point numbers, based on
  [this blog post](https://randomascii.wordpress.com/2012/02/25/comparing-floating-point-numbers-2012-edition/)
  by Bruce Dawson.
  """
  @spec close_enough?(number, number, number, non_neg_integer) :: boolean
  def close_enough?(a, b, epsilon, max_ulps) do
    a = :erlang.float a
    b = :erlang.float b

    cond do
      abs(a - b) <= epsilon -> true

      signbit(a) != signbit(b) -> false

      ulp_diff(a, b) <= max_ulps -> true

      true -> false
    end
  end

  @spec signbit(float) :: boolean
  defp signbit(x) do
    case <<x :: float>> do
      <<1 :: 1, _ :: bitstring>> -> true
      _ -> false
    end
  end

  @spec ulp_diff(float, float) :: integer
  def ulp_diff(a, b), do: abs(as_int(a) - as_int(b))

  @spec as_int(float) :: non_neg_integer
  defp as_int(x) do
    <<int :: 64>> = <<x :: float>>
    int
  end
end
