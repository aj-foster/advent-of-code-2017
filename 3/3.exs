# Advent of Code 2017
# Day 3
#

defmodule Advent3 do
  defp east(ring), do: (4 * :math.pow(ring, 2) - 3 * ring + 1)
  defp north_east(ring), do: (4 * :math.pow(ring, 2) - 2 * ring + 1)
  defp north(ring), do: (4 * :math.pow(ring, 2) - ring + 1)
  defp north_west(ring), do: (4 * :math.pow(ring, 2) + 1)
  defp west(ring), do: (4 * :math.pow(ring, 2) + ring + 1)
  defp south_west(ring), do: (4 * :math.pow(ring, 2) + 2 * ring + 1)
  defp south(ring), do: (4 * :math.pow(ring, 2) + 3 * ring + 1)

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
end

number = System.argv()
|> Enum.at(0)
|> String.to_integer()

number
|> Advent3.distance()
|> IO.inspect(label: "Distance")
