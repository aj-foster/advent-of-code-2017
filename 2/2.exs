defmodule Advent2 do
  def parse(stream) do
    stream
    |> Enum.map(fn (line) ->
      line
      |> String.trim()
      |> String.split(["\t", " "])
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def checksum(table) do
    Enum.reduce(table, 0, &difference/2)
  end

  def difference(row, sum) do
    start = row
    |> Enum.at(0)

    {min, max} = row
    |> Enum.reduce({start, start}, fn (x, acc) ->
      min = if elem(acc, 0) < x, do: elem(acc, 0), else: x
      max = if elem(acc, 1) > x, do: elem(acc, 1), else: x

      {min, max}
    end)

    sum + (max - min)
  end
end

System.argv()
|> Enum.at(0)
|> File.stream!()
|> Advent2.parse()
|> Advent2.checksum()
|> IO.inspect(label: "Checksum")
