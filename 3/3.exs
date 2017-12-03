# Advent of Code 2017
# Day 3
#
# In this challenge, we deal with a 2-dimensional spiral of numbers. The first
# part asks us to find the length of the shortest path from a particular number
# to the origin. The second part asks us to progress through the numbers and
# create sums in a geometric fashion, reporting the first number greater than
# our landmark. For each part, I've conceptually divided the grid into 8 parts
# and noted some patterns in the numbers on the axes / boundaries of the parts.
#
#                               [North]
#
#      4r^2 + 1 -- 65              61              57 -- 4r^2 - 2p + 1
#                      37          34          31
#                          17      15      13
#      [West]                   5   4   3                   [East]
#                  69  40  19   6   1   2  11  28  53
#  4r^2 + r + 1 ---^            7   8   9           ^--- 4r^2 - 3r + 1
#                          21      23      25
#                      43          46          49
#                  73              77              81 -- 4r^2 + 4r + 1
#  4r^2 + 2r + 1 --^
#                               [South]
#
# where r is the "ring number", a zero-based indication of how far the number
# is from the origin (1). The directions are used to describe where we are as
# we narrow in on the location of a number.
#

defmodule Advent3 do
  @moduledoc """
  This module exports two functions, distance/1 for part 1 and sum_after/1 for
  part 2. It also has a number of helpers which describe the algebra of the
  grid's numbers in terms of rings and cardinal directions.
  """

  # The following described numbers at the various poles and axes based on the
  # ring number. We use these as landmarks throughout the challenge.
  defp east(ring), do: trunc(4 * :math.pow(ring, 2) - 3 * ring + 1)
  defp north_east(ring), do: trunc(4 * :math.pow(ring, 2) - 2 * ring + 1)
  defp north(ring), do: trunc(4 * :math.pow(ring, 2) - ring + 1)
  defp north_west(ring), do: trunc(4 * :math.pow(ring, 2) + 1)
  defp west(ring), do: trunc(4 * :math.pow(ring, 2) + ring + 1)
  defp south_west(ring), do: trunc(4 * :math.pow(ring, 2) + 2 * ring + 1)
  defp south(ring), do: trunc(4 * :math.pow(ring, 2) + 3 * ring + 1)
  defp south_east(ring), do: trunc(4 * :math.pow(ring, 2) + 4 * ring + 1)

  @doc """
  Accepts a positive integer and returns the taxi distance to the origin.

  This function uses a sort of binary search. We divide the remaining space
  approximately in half (described using cardinal directions) by comparing the
  number to the formulas mentioned in the diagram above.
  """
  @spec distance(integer) :: integer
  def distance(number) do
    case number do
      1 -> 0

      x when x > 1 ->
        number
        |> northeast_or_southwest(ring(number))
        |> trunc()

      _ ->
        raise "Invalid input"
    end
  end

  # Note that the final number in a ring is the square (2r + 1)^2. As the ring
  # number r increases, rings end with the squares of consecutive odd numbers.
  #
  # Thus we can take (2r + 1)^2 = 4r^2 + 4r + 1 = x as a quadratic equation we
  # wish to solve. This will tell us in which ring the number x resides. After
  # subtracting on both sides, we can use the quadratic equation:
  #
  #       -4 ± sqrt(16 - 16x)
  #   r = -------------------
  #                8
  #
  #     = (-1/2) ± (1/2) * sqrt(x)
  #
  # Since we want a positive ring number, we choose the "+" option. The last
  # step is to recognize that this gives us an integer for the squares of odd
  # numbers. For the rest, we wait to use the ceiling function. (Recall the
  # square of an odd number is the last number in a ring, so all others should
  # be raised to the next highest integer.) Our final formula is:
  #
  #   r = (1/2) * sqrt(x) - (1/2)
  #
  @spec ring(integer) :: integer
  defp ring(number) do
    (0.5 * :math.sqrt(number) - 0.5)
    |> Float.ceil()
    |> trunc()
  end

  # First step: divide between the North+East side and the South+West side.
  @spec west_or_south(integer, integer) :: integer
  defp northeast_or_southwest(number, ring) do
    case number - north_west(ring) do
      x when x < 0 ->
        # North or East
        north_or_east(number, ring)

      0 ->
        # Exactly Northwest. The distance is the distance to an X or Y axis (r)
        # plus the number of rings to get to the origin (r again).
        2 * ring

      x when x > 0 ->
        # West or South
        west_or_south(number, ring)
    end
  end

  # Second step: divide between the North quarter and the East quarter.
  @spec west_or_south(integer, integer) :: integer
  defp north_or_east(number, ring) do
    case number - north_east(ring) do
      x when x < 0 ->
        # East
        abs(number - east(ring)) + ring

      0 ->
        # Exactly Northeast. The distance is the distance to an X or Y axis (r)
        # plus the number of rings to get to the origin (r again).
        2 * ring

      x when x > 0 ->
        # North
        abs(number - north(ring)) + ring
    end
  end

  # Second step: divide between the West quarter and the South quarter.
  @spec west_or_south(integer, integer) :: integer
  defp west_or_south(number, ring) do
    case number - south_west(ring) do
      x when x < 0 ->
        # West
        abs(number - west(ring)) + ring

      0 ->
        # Exactly Southwest. The distance is the distance to an X or Y axis (r)
        # plus the number of rings to get to the origin (r again).
        2 * ring

      x when x > 0 ->
        # South
        abs(number - south(ring)) + ring
    end
  end

  # Part 2:

  @doc """
  Accepts a positive integer and returns the next sum that appears in the
  modified grid described in part 2.

  We begin the recursive calls with a number of prefilled entries. This allows
  us to ignore a number of special cases that occur due to the first ring. The
  recursive calls will add on to the array of known sums until the desired
  number is found.
  """
  @spec sum_after(integer) :: integer
  def sum_after(number) do
    sum_after([1, 1, 2, 4, 5, 10, 11, 23, 25, 26], number)
  end

  # Find the next sum and continue or return if the desired number is found.
  #
  # This function is a giant conditional that looks at the position of the next
  # number to find and picks out the other numbers necessary to sum.
  #
  @spec sum_after(list(integer), integer) :: integer
  defp sum_after(sums, number) do
    i = Enum.count(sums) + 1
    r = ring(i)
    prev = Enum.at(sums, i - 2)

    next = prev + cond do
      #
      #  x |
      # ---/
      #  p   *
      #
      i == south_east(r - 1) + 1 ->
        Enum.at(sums, south_east(r - 2))

      #
      #  x | *
      # ---/
      #  x   p
      #
      i == south_east(r - 1) + 2 ->
        Enum.at(sums, i - 3) +
        Enum.at(sums, south_east(r - 2) + 1) +
        Enum.at(sums, south_east(r - 2))

      #
      #  x |
      #    |
      #  x | *
      #    |
      #  x | p
      #
      i < north_east(r) - 1 ->
        Enum.at(sums, i - 8 * r + 5) +
        Enum.at(sums, i - 8 * r + 6) +
        Enum.at(sums, i - 8 * r + 7)

      #
      # ---\
      #  x | *
      #    |
      #  x | p
      #
      i == north_east(r) - 1 ->
        Enum.at(sums, north_east(r - 1) - 1) +
        Enum.at(sums, north_east(r - 1) - 2)

      #
      #      *
      # ---\
      #  x | p
      #
      i == north_east(r) ->
        Enum.at(sums, north_east(r - 1) - 1)

      #
      #     *   p
      # ------\
      #  x  x | x
      #
      i == north_east(r) + 1 ->
        Enum.at(sums, i - 3) +
        Enum.at(sums, north_east(r - 1)) +
        Enum.at(sums, north_east(r - 1) - 1)

      #
      #     *  p
      # ---------
      #  x  x  x
      #
      i < north_west(r) - 1 ->
        Enum.at(sums, i - 8 * r + 3) +
        Enum.at(sums, i - 8 * r + 4) +
        Enum.at(sums, i - 8 * r + 5)

      #
      #   *  p
      # /-----
      # | x  x
      #
      i == north_west(r) - 1 ->
        Enum.at(sums, north_west(r - 1) - 1) +
        Enum.at(sums, north_west(r - 1) - 2)

      #
      #  *   p
      #    /---
      #    | x
      #
      i == north_west(r) ->
        Enum.at(sums, north_west(r - 1) - 1)

      #
      #  p   x
      #    /---
      #  * | x
      #    |
      #    | x
      #
      i == north_west(r) + 1 ->
        Enum.at(sums, i - 3) +
        Enum.at(sums, north_west(r - 1)) +
        Enum.at(sums, north_west(r - 1) - 1)

      #
      #  p | x
      #    |
      #  * | x
      #    |
      #    | x
      #
      i < south_west(r) - 1 ->
        Enum.at(sums, i - 8 * r + 1) +
        Enum.at(sums, i - 8 * r + 2) +
        Enum.at(sums, i - 8 * r + 3)

      #
      #  p | x
      #    |
      #  * | x
      #    \---
      #
      i == south_west(r) - 1 ->
        Enum.at(sums, south_west(r - 1) - 1) +
        Enum.at(sums, south_west(r - 1) - 2)

      #
      #  p | x
      #    \---
      #  *
      #
      i == south_west(r) ->
        Enum.at(sums, south_west(r - 1) - 1)

      #
      #  x | x  x
      #    \------
      #  p   *
      #
      i == south_west(r) + 1 ->
        Enum.at(sums, i - 3) +
        Enum.at(sums, south_west(r - 1)) +
        Enum.at(sums, south_west(r - 1) - 1)

      #
      #  x  x  x
      # ---------
      #  p  *
      #
      i < south_east(r) ->
        Enum.at(sums, i - 8 * r - 1) +
        Enum.at(sums, i - 8 * r ) +
        Enum.at(sums, i - 8 * r + 1)

      #
      #  x  x |
      # ------/
      #  p  *
      #
      i == south_east(r) ->
        Enum.at(sums, south_east(r - 1)) +
        Enum.at(sums, south_east(r - 1) - 1)

      true ->
        raise "Part 2: Unknown case for index #{i}"
    end

    # If the number we found is greater than the threshold, return it. Otherwise
    # make a recursive call to find the next number.
    cond do
      next > number ->
        next

      true ->
        sum_after(sums ++ [next], number)
    end
  end
end

# Accept a number as the first argument.
number = System.argv()
|> Enum.at(0)
|> String.to_integer()

# Calculate the distance for part 1.
number
|> Advent3.distance()
|> IO.inspect(label: "Distance")

# Calculate the sum for part 2.
number
|> Advent3.sum_after()
|> IO.inspect(label: "Sum after")
