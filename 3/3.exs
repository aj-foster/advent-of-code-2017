# Advent of Code 2017
# Day 3
#

defmodule Advent3 do
  defp east(ring), do: trunc(4 * :math.pow(ring, 2) - 3 * ring + 1)
  defp north_east(ring), do: trunc(4 * :math.pow(ring, 2) - 2 * ring + 1)
  defp north(ring), do: trunc(4 * :math.pow(ring, 2) - ring + 1)
  defp north_west(ring), do: trunc(4 * :math.pow(ring, 2) + 1)
  defp west(ring), do: trunc(4 * :math.pow(ring, 2) + ring + 1)
  defp south_west(ring), do: trunc(4 * :math.pow(ring, 2) + 2 * ring + 1)
  defp south(ring), do: trunc(4 * :math.pow(ring, 2) + 3 * ring + 1)
  defp south_east(ring), do: trunc(4 * :math.pow(ring, 2) + 4 * ring + 1)

  defp a <~> b do
    c = a - b

    cond do
      c <  0 -> -1
      c == 0 ->  0
      c >  0 ->  1
    end
  end

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

  def ring(number) do
    (0.5 * :math.sqrt(number) - 0.5)
    |> Float.ceil()
    |> trunc()
  end

  defp northeast_or_southwest(number, ring) do
    case (number <~> north_west(ring)) do
      -1 ->
        # North or East
        north_or_east(number, ring)

      0 ->
        # Exactly Northwest
        2 * ring

      1 ->
        # West or South
        west_or_south(number, ring)
    end
  end

  defp north_or_east(number, ring) do
    case (number <~> north_east(ring)) do
      -1 ->
        # East
        ene_or_ese(number, ring)

      0 ->
        # Exactly Northeast
        2 * ring

      1 ->
        # North
        nne_or_nnw(number, ring)
    end
  end

  defp west_or_south(number, ring) do
    case (number <~> south_west(ring)) do
      -1 ->
        # West
        wnw_or_wsw(number, ring)

      0 ->
        # Exactly Southwest
        2 * ring

      1 ->
        # South
        ssw_or_sse(number, ring)
    end
  end

  defp ene_or_ese(number, ring) do
    abs(number - east(ring)) + ring
  end

  defp nne_or_nnw(number, ring) do
    abs(number - north(ring)) + ring
  end

  defp wnw_or_wsw(number, ring) do
    abs(number - west(ring)) + ring
  end

  defp ssw_or_sse(number, ring) do
    abs(number - south(ring)) + ring
  end



  def sum_after(number) do
    sum_after([1, 1, 2, 4, 5, 10, 11, 23, 25, 26], number)
  end

  defp sum_after(sums, number) do
    i = Enum.count(sums) + 1
    r = ring(i)
    prev = Enum.at(sums, i - 2)

    next = cond do
      i == south_east(r - 1) + 1 ->
        prev +
        Enum.at(sums, south_east(r - 2))

      i == south_east(r - 1) + 2 ->
        prev +
        Enum.at(sums, i - 3) +
        Enum.at(sums, south_east(r - 2) + 1) +
        Enum.at(sums, south_east(r - 2))

      i < north_east(r) - 1 ->
        prev +
        Enum.at(sums, i - 8 * r + 5) +
        Enum.at(sums, i - 8 * r + 6) +
        Enum.at(sums, i - 8 * r + 7)

      i == north_east(r) - 1 ->
        prev +
        Enum.at(sums, north_east(r - 1) - 1) +
        Enum.at(sums, north_east(r - 1) - 2)

      i == north_east(r) ->
        prev +
        Enum.at(sums, north_east(r - 1) - 1)

      i == north_east(r) + 1 ->
        prev +
        Enum.at(sums, i - 3) +
        Enum.at(sums, north_east(r - 1)) +
        Enum.at(sums, north_east(r - 1) - 1)

      i < north_west(r) - 1 ->
        prev +
        Enum.at(sums, i - 8 * r + 3) +
        Enum.at(sums, i - 8 * r + 4) +
        Enum.at(sums, i - 8 * r + 5)

      i == north_west(r) - 1 ->
        prev +
        Enum.at(sums, north_west(r - 1) - 1) +
        Enum.at(sums, north_west(r - 1) - 2)

      i == north_west(r) ->
        prev +
        Enum.at(sums, north_west(r - 1) - 1)

      i == north_west(r) + 1 ->
        prev +
        Enum.at(sums, i - 3) +
        Enum.at(sums, north_west(r - 1)) +
        Enum.at(sums, north_west(r - 1) - 1)

      i < south_west(r) - 1 ->
        prev +
        Enum.at(sums, i - 8 * r + 1) +
        Enum.at(sums, i - 8 * r + 2) +
        Enum.at(sums, i - 8 * r + 3)

      i == south_west(r) - 1 ->
        prev +
        Enum.at(sums, south_west(r - 1) - 1) +
        Enum.at(sums, south_west(r - 1) - 2)

      i == south_west(r) ->
        prev +
        Enum.at(sums, south_west(r - 1) - 1)

      i == south_west(r) + 1 ->
        prev +
        Enum.at(sums, i - 3) +
        Enum.at(sums, south_west(r - 1)) +
        Enum.at(sums, south_west(r - 1) - 1)

      i < south_east(r) ->
        prev +
        Enum.at(sums, i - 8 * r - 1) +
        Enum.at(sums, i - 8 * r ) +
        Enum.at(sums, i - 8 * r + 1)

      i == south_east(r) ->
        prev +
        Enum.at(sums, south_east(r - 1)) +
        Enum.at(sums, south_east(r - 1) - 1)

      true ->
        raise "Unknown case for #{i}"
    end

    cond do
      next <= number ->
        sum_after(sums ++ [next], number)

      true ->
        next
    end
  end
end

number = System.argv()
|> Enum.at(0)
|> String.to_integer()

number
|> Advent3.distance()
|> IO.inspect(label: "Distance")

number
|> Advent3.sum_after()
|> IO.inspect(label: "Sum after")
