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
end
