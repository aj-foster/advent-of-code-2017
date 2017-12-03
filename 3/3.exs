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
    case (number <~> east(ring)) do
      -1 ->
        # East South East
        east(ring) - number + ring

      0 ->
        # Exactly East
        ring

      1 ->
        # East North East
        number - east(ring) + ring
    end
  end

  defp nne_or_nnw(number, ring) do
    case (number <~> north(ring)) do
      -1 ->
        # North Northeast
        north(ring) - number + ring

      0 ->
        # Exactly North
        ring

      1 ->
        # North North West
        number - north(ring) + ring
    end
  end

  defp wnw_or_wsw(number, ring) do
    case (number <~> west(ring)) do
      -1 ->
        # West Northwest
        west(ring) - number + ring

      0 ->
        # Exactly West
        ring

      1 ->
        # West Southwest
        number - west(ring) + ring
    end
  end

  defp ssw_or_sse(number, ring) do
    case (number <~> south(ring)) do
      -1 ->
        # South Southwest
        south(ring) - number + ring

      0 ->
        # Exactly South
        ring

      1 ->
        # South Southeast
        number - south(ring) + ring
    end
  end
end

number = System.argv()
|> Enum.at(0)
|> String.to_integer()

number
|> Advent3.distance()
|> IO.inspect(label: "Distance")
