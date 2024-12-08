defmodule Day2 do
  def readInput(raw) do
    raw
      |> String.split("\n")
      |> Stream.filter(fn l -> l != "" end)
      |> Stream.map(fn r -> Enum.map(String.split(r), &String.to_integer/1) end)
  end

  def part1(reports) do
    reports
      |> Stream.map(&safe?/1)
      |> Enum.count(&(&1))
  end

  defp safe?(_report = [n1, n2, n3]) do
    diff1 = n1 - n2
    diff2 = n2 - n3
    decent_diffs(diff1, diff2)
  end

  defp safe?(_report = [n1, n2, n3 | rest]) do
    diff1 = n1 - n2
    diff2 = n2 - n3
    if decent_diffs(diff1, diff2) do
      safe?([n2, n3 | rest])
    else
      false
    end
  end

  defp sign(n) when n >= 0, do: :positive # zero goes here because I don't care
  defp sign(_), do: :negative

  defp decent_diff(diff), do: abs(diff) >= 1 && abs(diff) <= 3

  defp decent_diffs(diff1, diff2) do
    sign(diff1) == sign(diff2)
      && decent_diff(diff1)
      && decent_diff(diff2)
  end

  def part2(reports) do
    # stupid solution because I am unable to come up with a better one
    reports
      |> Stream.map(&({&1, safe?(&1)}))
      |> Stream.map(fn
          { _, true  } -> true
          { report, false } ->
            Enum.any?(Enum.map(subreports(report), fn subreport -> safe?(subreport) end))
        end)
      |> Enum.count(&(&1))
  end

  defp subreports(report) do
    Enum.map(0..length(report), fn idx -> List.delete_at(report, idx) end)
  end
end
