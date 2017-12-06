# Advent of Code 2017
# Day 5

defmodule Advent5 do
  def escape(list, index \\ 0) do
    cond do
      index < Enum.count(list) ->
        list
        |> List.replace_at(index, Enum.at(list, index) + 1)
        |> escape(index + Enum.at(list, index))
        |> Kernel.+(1)

      true ->
        0
    end
  end

  def escape2(list, index \\ 0) do
    cond do
      index < Enum.count(list) ->
        jump = list
        |> Enum.at(index)

        case jump > 2 do
          true ->
            list
            |> List.replace_at(index, jump - 1)
            |> escape2(index + jump)
            |> Kernel.+(1)

          false ->
            list
            |> List.replace_at(index, jump + 1)
            |> escape2(index + jump)
            |> Kernel.+(1)
        end

      true -> 0
    end
  end
end

list = System.argv()
|> Enum.at(0)
|> File.stream!()
|> Enum.map(fn (line) ->
  line
  |> String.trim()
  |> String.to_integer()
end)

list
|> Advent5.escape()
|> IO.inspect(label: "Part 1")

list
|> Advent5.escape2()
|> IO.inspect(label: "Part 2")
