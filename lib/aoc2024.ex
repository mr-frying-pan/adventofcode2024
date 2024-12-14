defmodule Aoc2024 do
  def day1 do
    {list1, list2} = Day1.readInput(File.read!("lib/Day1/input"))
    {
      Day1.part1(list1, list2),
      Day1.part2(list1, list2)
    }
  end

  def day2 do
    reports = Day2.readInput(File.read!("lib/Day2/input"))
    {
      Day2.part1(reports),
      Day2.part2(reports)
    }
  end

  def day3 do
    corrupted = Day3.readInput(File.read!("lib/Day3/input"))
    {
      Day3.part1(corrupted),
      Day3.part2(corrupted)
    }
  end

  def day4 do
    sheet = Day4.readInput(File.read!("lib/Day4/input"))
    {
      Day4.part1(sheet),
      Day4.part2(sheet)
    }
  end

  def day5() do
    { rules, updates } = Day5.readInput(File.read!("lib/Day5/input"))
    {
      Day5.part1(rules, updates),
      Day5.part2(rules, updates)
    }
  end

  def day6() do
    map = Day6.readInput(File.read!("lib/Day6/lil_input"))
    {
      Day6.part1(map),
      # Day6.part2(map)
    }
  end

  def day7() do
    equations = Day7.readInput(File.read!("lib/Day7/input"))
    {
      Day7.part2(equations)
    }
  end

  def day11() do
    stones = Day11.readInput(File.read!("lib/Day11/input"))
    {
      Day11.part1(stones),
      Day11.part2(stones)
    }
  end

  def day12() do
    plot = Day12.readInput(File.read!("lib/Day12/input"))
    {
      Day12.part1(plot),
      Day12.part2(plot)
    }
  end
end
