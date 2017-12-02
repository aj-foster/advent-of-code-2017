# Advent of Code 2017
# Day 1
#
# For this challenge, we take a list of numbers (input to this script as a
# string) and, for part 1, sum when two consecutive numbers are the same. I've
# used this as an opportunity to practice recursion in Elixir. Similarly, in
# part 2, we are asked to sum numbers when they match "halfway around" the list.
# For this part, I use the intuition that scanning half of the list for matches
# with the second half of the list is sufficient if we multiply the end result
# by two.

defmodule Advent1 do
  @moduledoc """
  This module exports two functions, parse/1 and parse2/1, which accept a list
  of numbers representing the digits of the input string. They return the
  tallies described in part 1 and 2 of the day one exercise, respectively.
  """

  @doc """
  Accept a number as a integer list of digits and return the part 1 tally.
  """
  @spec parse(list(integer)) :: integer
  def parse(number) do
    first = number
    |> Enum.at(0)

    number
    |> tally(first)
  end


  # tally/2 is a recursive function that acts on the integer list of digits.

  # Case: Two consecutive numbers are the same. Add number to recursive call.
  defp tally([a, a | tail], first) do
    a + tally([a | tail], first)
  end

  # Case: Two different consecutive numbers. Return recursive call.
  defp tally([a, b | tail], first) when b != a do
    tally([b | tail], first)
  end

  # Base case: last digit in the list is the same as the first. Return digit.
  defp tally([a], a), do: a

  # Base case: last digit in the list is different from the first. Return 0.
  defp tally([a], b) when b != a, do: 0


  @doc """
  Accept a number as an integer list of digits and return the part 2 tally.
  """
  @spec parse2(list(integer)) :: integer
  def parse2(number) do
    length = number
    |> Enum.count()

    {half1, half2} = number
    |> Enum.split(Integer.floor_div(length, 2))

    tally2(half1, half2)
    |> Kernel.*(2)
  end


  # tally2/2 is a recursive function that acts on the integer list of digits.

  # Base case: last digits of the lists match. Return digit.
  defp tally2([a], [a]), do: a

  # Base case: last digits of the list do not match. Return 0.
  defp tally2([a], [b]) when b != a, do: 0

  # Case: Two digits match halfway around the list. Add digit to recursive call.
  defp tally2([a | tail1], [a | tail2]) do
    a + tally2(tail1, tail2)
  end

  # Case: Two digits halfway around the list don't match. Return recursive call.
  defp tally2([a | tail1], [b | tail2]) when b != a do
    tally2(tail1, tail2)
  end
end


# Accept a number as a string from standard input, change it to a character
# list, convert it to a list of digits, then parse.
#
number = System.argv()
|> Enum.at(0)
|> String.to_charlist()
|> Enum.map(fn(x) ->
  [x]
  |> List.to_string()
  |> String.to_integer()
end)

# Part 1
number
|> Advent1.parse()
|> IO.inspect(label: "Tally 1")

# Part 2
number
|> Advent1.parse2()
|> IO.inspect(label: "Tally 2")
