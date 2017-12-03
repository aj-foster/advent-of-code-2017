# Advent of Code 2017
# Day 2
#
# For this challenge, we take a makeshift spreadsheet and calculate a checksum
# by summing the differences between the maximum and minimum numbers in each
# row. 

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


  def checksum2(table) do
    Enum.reduce(table, 0, &division/2)
  end

  def division(row, sum) do
    row
    |> IO.inspect(label: "Considering")
    |> Enum.reduce_while(0, fn (a, _acc) ->
      row
      |> Enum.find(fn (b) ->
        a != b
        && rem(a, b) == 0
      end)
      |> case do
        nil ->
          {:cont, 0}
        b ->
          IO.puts("Found #{b} | #{a} to give #{div(a, b)}")
          {:halt, div(a, b)}
      end
    end)
    |> Kernel.+(sum)
  end
end

table = System.argv()
|> Enum.at(0)
|> File.stream!()
|> Advent2.parse()

table
|> Advent2.checksum()
|> IO.inspect(label: "Checksum")

table
|> Advent2.checksum2()
|> IO.inspect(label: "Checksum 2")
