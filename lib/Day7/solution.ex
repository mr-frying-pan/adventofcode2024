defmodule Day7 do
  defmodule Equation do
    defstruct result: 0, values: []
  end

  def readInput(raw) do
    raw
      |> String.split("\n")
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(fn line ->
                    [ res_str, values_str ] = String.split(line, ":")
                    values = values_str
                      |> String.split()
                      |> Enum.map(&String.to_integer/1)
                    %Equation{result: String.to_integer(res_str), values: values}
                  end)
  end

  def part2(equations) do
    equations
      |> Enum.map(fn eqn = %Equation{result: res} -> { res, is_possible?(eqn) } end)
      |> Enum.filter(fn { _, possible } -> possible end)
      |> Enum.map(fn { res, _ } -> res end)
      |> Enum.sum()
  end

  defp is_possible?(%Equation{result: res, values: [val | vals]}) do
    is_possible?(res, val, vals)
  end

  defp is_possible?(goal, acc, []) do
    if acc == goal do
      true
    else
      false
    end
  end

  defp is_possible?(goal, acc, [val | vals]) do
    is_possible?(goal, acc + val, vals)
    or is_possible?(goal, acc * val, vals)
    or is_possible?(goal, String.to_integer(Integer.to_string(acc) <> Integer.to_string(val)), vals)
  end
end
