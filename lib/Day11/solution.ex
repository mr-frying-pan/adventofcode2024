defmodule Day11 do
  def readInput(raw) do
    raw
      |> String.split()
      |> Enum.map(&String.to_integer/1)
  end

  def part1(stones) do
    length(blink(stones, 25))
  end

  defp blink(stones, 0), do: stones
  defp blink(stones, n) do
    blink(blink_line(stones), n - 1)
  end

  defp blink_line([]), do: []
  defp blink_line([stone | stones]) do
    case blink_stone(stone) do
      [new_stone] -> [new_stone | blink_line(stones)]
      [new_stone1, new_stone2] -> [new_stone1 | [ new_stone2 | blink_line(stones) ] ]
    end
  end

  defp blink_stone(stone) do
    str_stone = Integer.to_string(stone)
    str_stone_length = String.length(str_stone)
    cond do
      stone == 0 -> [1]
      rem(str_stone_length, 2) == 0 ->
        { left, right } = String.split_at(str_stone, div(str_stone_length, 2))
        [String.to_integer(left), String.to_integer(right)]
      true -> [stone * 2024]
    end
  end

  def part2(stones) do
    Enum.map(stones,
      fn stone ->
        IO.inspect(stone)
        stones_25 = blink([stone], 25)
        IO.inspect({"Stones 25", length(stones_25)})
        stones_25
          |> Enum.map(fn stone_25 -> Task.async(fn -> blink([stone_25], 25) end) end)
          |> Enum.map(fn task_50 ->
                        stones_50 = Task.await(task_50, :infinity)
                        IO.inspect({ "Stones 50", length(stones_50)})
                        stones_50
                          |> Enum.map(fn stone_50 -> Task.async(fn -> blink([stone_50], 25) end) end)
                          |> Enum.map(fn task_75 -> length(Task.await(task_75, :infinity)) end)
                          |> Enum.sum()
                      end)
          |> Enum.sum()
      end)
  end
end
