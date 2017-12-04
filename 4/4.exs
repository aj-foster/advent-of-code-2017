filename = System.argv()
|> Enum.at(0)

filename
|> File.stream!()
|> Stream.map(fn (line) ->
  line
  |> String.trim()
  |> String.split(" ", trim: true)
end)
|> Stream.filter(fn (list) ->
  uniq_words = list
  |> Enum.uniq()
  |> Enum.count()

  Enum.count(list) == uniq_words
end)
|> Enum.count()
|> IO.inspect(label: "Part 2")

filename
|> File.stream!()
|> Stream.map(fn (line) ->
  line
  |> String.trim()
  |> String.split(" ", trim: true)
  |> Enum.map(fn (word) ->
    word
    |> String.to_charlist()
    |> Enum.sort()
  end)
end)
|> Stream.filter(fn (list) ->
  uniq_words = list
  |> Enum.uniq()
  |> Enum.count()

  Enum.count(list) == uniq_words
end)
|> Enum.count()
|> IO.inspect(label: "Part 1")
