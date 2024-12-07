defmodule Day3.Solution do
  def readInput(raw) do
    raw
  end

  def part1(corrupted) do
    regex = ~r/mul\((\d+),(\d+)\)/
    Regex.scan(regex, corrupted)
      |> Stream.map(fn [_, n1, n2] -> String.to_integer(n1) * String.to_integer(n2) end)
      |> Enum.sum()
  end

  def part2(corrupted) do
    regex = ~r/mul\((\d+),(\d+)\)|do\(\)|don't\(\)/
    process_instructions(Regex.scan(regex, corrupted), true)
      |> Enum.sum()
  end

  defp process_instructions([], _), do: []

  defp process_instructions([instr | rest], doing) do
    case instr do
      [_, n1, n2] -> [
        (if doing do
          String.to_integer(n1) * String.to_integer(n2)
        else
          0
        end) | process_instructions(rest, doing)]
      ["do()"]    -> [0 | process_instructions(rest, true)]
      ["don't()"] -> [0 | process_instructions(rest, false)]
    end
  end
end
