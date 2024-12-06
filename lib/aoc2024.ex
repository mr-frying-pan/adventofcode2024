defmodule Aoc2024 do
  def task1 do
    {list1, list2} = Task1.Solution.readInput(File.read!("lib/Task1/input"))
    {
      Task1.Solution.part1(list1, list2),
      Task1.Solution.part2(list1, list2)
    }
  end
end
