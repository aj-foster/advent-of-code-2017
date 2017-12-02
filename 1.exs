# Advent of Code 2017
# Day 1
#
# For this challenge, we take a list of numbers (input to this script as a
# string) and sum when two consecutive numbers are the same. I've used this
# as an opportunity to practice recursion in Elixir.

defmodule Advent1 do
  @moduledoc """
  This module exports one function, parse/1, which accepts a list of numbers
  representing the digits. It returns the tally described in the day 1 exercise.
  """

  @doc """
  Accept a number as a integer list of digits and return the tally.
  """
  @spec parse(list(integer)) :: integer
  def parse(number) do
    first = number
    |> Enum.at(0)

    number
    |> tally(first)
  end


  # tally/2 is a recursive function that acts on the character list of digits.

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


  defp tally2([a], [a]), do: a


  defp tally2([a], [b]) when b != a, do: 0


  defp tally2([a | tail1], [a | tail2]) do
    a + tally2(tail1, tail2)
  end


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

number
|> Advent1.parse()
|> IO.inspect(label: "Tally 1")

number
|> Advent1.parse2()
|> IO.inspect(label: "Tally 2")
