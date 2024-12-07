defmodule Aoc2024Test do
  use ExUnit.Case

  test "solves day 1 task" do
    assert IO.inspect(Aoc2024.day1())
  end

  test "solves day 2 task" do
    assert IO.inspect(Aoc2024.day2())
  end

  @tag current: true
  test "solves day 3 task" do
    assert IO.inspect(Aoc2024.day3())
  end
end
