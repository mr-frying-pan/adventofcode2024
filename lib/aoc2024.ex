defmodule Aoc2024 do
  def day1 do
    {list1, list2} = Day1.Solution.readInput(File.read!("lib/Day1/input"))
    {
      Day1.Solution.part1(list1, list2),
      Day1.Solution.part2(list1, list2)
    }
  end

  def day2 do
    reports = Day2.Solution.readInput(File.read!("lib/Day2/input"))
    {
      Day2.Solution.part1(reports),
      Day2.Solution.part2(reports)
    }
  end

  def day3 do
    corrupted = Day3.Solution.readInput(File.read!("lib/Day3/input"))
    {
      Day3.Solution.part1(corrupted),
      Day3.Solution.part2(corrupted)
    }
  end
end
