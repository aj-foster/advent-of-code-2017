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
    |> IO.inspect(label: "Tally")
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
end


# Accept a number as a string from standard input, change it to a character
# list, convert it to a list of digits, then parse.
#
System.argv()
|> Enum.at(0)
|> String.to_charlist()
|> Enum.map(fn(x) ->
  [x]
  |> List.to_string()
  |> String.to_integer()
end)
|> Advent1.parse()
