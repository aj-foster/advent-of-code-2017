# Advent of Code 2017
# Day 2
#
# For this challenge, we take a makeshift spreadsheet and calculate a checksum
# by summing the differences between the maximum and minimum numbers in each
# row. In part 2, we sum the division of the (assumed distinct) pair of numbers
# in each row that can divide each other evenly.

defmodule Advent2 do
  @moduledoc """
  This module exports functions for parsing the input files (either as space-
  or tab-separated rows of numbers) and completing both parts of the challenge.
  """

  @doc """
  Accept a File.Stream and construct a two-dimensional list of integers.

  This function accepts files which are tab- and space-separated, with newlines.
  """
  @spec parse(File.Stream) :: list(list(integer))
  def parse(stream) do
    stream
    |> Enum.map(fn (line) ->
      line
      |> String.trim()
      |> String.split(["\t", " "])
      |> Enum.map(&String.to_integer/1)
    end)
  end

  @doc """
  Calculate the checksum for part 1 of the challenge.

  We reduce the list of lists using difference/2. Here the accumulator
  represents the sum of the checksum.
  """
  @spec checksum(list(list(integer))) :: integer
  def checksum(table) do
    Enum.reduce(table, 0, &difference/2)
  end

  # Calculate the difference between the maximum and minimum row elements.
  @spec difference(list(integer), integer) :: integer
  defp difference(row, sum) do
    # Find the minimum and maximum elements of the row.
    {min, max} = row
    |> Enum.min_max()

    # Add the row's difference to our accumulated sum.
    sum + (max - min)
  end

  @doc """
  Calculate the checksum for part 2 of the challenge.

  We reduce the list of lists using division/2. Here the accumulator once again
  represents the sum of the checksum.
  """
  @spec checksum2(list(list(integer))) :: integer
  def checksum2(table) do
    Enum.reduce(table, 0, &division/2)
  end

  # Find the distinct pair of divisible numbers and calculate the division.
  #
  # This function attempts to optimize the number of remainder checks performed
  # by using a few concepts:
  #
  # - a number divides at least one of (b, c, d) only if it divides (b * c * d)
  # - If x > y, x cannot divide y.
  #
  @spec division(list(integer), integer) :: integer
  defp division(row, sum) do
    # Calculate the product of all numbers in the list. This is an O(n) effort
    # that, together with finding the list of divisors, reduces the number of
    # remainder checks for my data set by 33%.
    product = row
    |> Enum.reduce(1, &Kernel.*/2)

    # Find which numbers in the list divide the product of all other numbers.
    # We use an equivalent calculation, that the number squared divides the
    # product of every number, including itself.
    divisors = row
    |> Enum.filter(fn (x) ->
      rem(product, x * x) == 0
    end)

    # Our outer reduction checks if the given element is a dividend.
    row
    |> Enum.reduce_while(0, fn (a, _acc) ->
      # Our inner reduction checks if the given element is a divisor of a.
      divisors
      |> Enum.find(fn (b) ->
        # Explicitly ignore the case of a / a = 1 r 0.
        a > b
        && rem(a, b) == 0
      end)
      |> case do
        # If it returns nil, it means no divisor was found. Keep looking.
        nil ->
          {:cont, 0}

        # If it returns a number, we have the pair of numbers for this row.
        b ->
          {:halt, div(a, b)}
      end
    end)
    |> Kernel.+(sum)
  end
end

# Accept the input file name as an argument.
table = System.argv()
|> Enum.at(0)
|> File.stream!()
|> Advent2.parse()

# Calculate the checksum for part 1.
table
|> Advent2.checksum()
|> IO.inspect(label: "Checksum")

# Calculate the checksum for part 2
table
|> Advent2.checksum2()
|> IO.inspect(label: "Checksum 2")
