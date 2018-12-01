# Advent of Code 2017
# Day 6

defmodule Day6 do
  def cycle(banks) do
    cycle(banks, %{[banks] => 1}, 1)
  end

  def cycle(banks, seen_banks, count) do
    banks = reallocate(banks)

    case match?(%{^banks => _}, seen_banks) do
      true ->
        {count, count - seen_banks[banks]}

      false ->
        seen_banks = Map.put(seen_banks, banks, count)
        cycle(banks, seen_banks, count + 1)
    end
  end

  def reallocate(banks) do
    len = length(banks)
    max = Enum.max(banks)
    max_index = Enum.find_index(banks, &(&1 == max))

    Enum.with_index(banks)
    |> Enum.map(fn {element, index} ->
      cond do
        index == max_index ->
          div(max, len)

        index < max_index ->
          cond do
            rem(max, len) >= len - max_index + index ->
              element + div(max, len) + 1

            true ->
              element + div(max, len)
          end

        index > max_index ->
          cond do
            rem(max, len) >= index - max_index ->
              element + div(max, len) + 1

            true ->
              element + div(max, len)
          end
      end
    end)
  end
end

{part1, part2} =
  File.read!("input.txt")
  |> String.split(~r/\s/, trim: true)
  |> Enum.map(&String.to_integer/1)
  |> Day6.cycle()

IO.inspect(part1, label: "Part 1")
IO.inspect(part2, label: "Part 2")
