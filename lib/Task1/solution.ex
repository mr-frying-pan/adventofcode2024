defmodule Task1.Solution do
  def readInput(raw) do
    raw
      |> String.split("\n")
      |> Stream.filter(fn line -> line != "" end)
      |> Stream.map(fn line -> List.to_tuple(String.split(line)) end)
      |> Enum.unzip()
  end

  def part1(list1, list2) do
    sortedList1 = Stream.map(list1, &String.to_integer/1)
      |> Enum.sort()
    sortedList2 = Stream.map(list2, &String.to_integer/1)
      |> Enum.sort()

    Stream.zip(sortedList1, sortedList2)
      |> Stream.map(fn {n1, n2} -> abs(n1 - n2) end)
      |> Enum.sum()
  end

  def part2(list1, list2) do
    list1
      |> Stream.map(fn n1 -> {n1, Enum.count(list2, fn n2 -> n1 == n2 end)} end)
      |> Stream.map(fn {n, freq} -> String.to_integer(n) * freq end)
      |> Enum.sum()
  end
end
