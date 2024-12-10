defmodule Day5 do
  def readInput(raw) do
    { rules, updates } = raw
      |> String.split("\n")
      |> Enum.split_while(fn l -> l != "" end)
    {
      rules
        |> Enum.map(fn rule -> rule |> String.split("|") |> List.to_tuple() end),
      updates
        |> Enum.filter(fn upd -> upd != "" end)
        |> Enum.map(fn upd -> String.split(upd, ",") end)
    }
  end

  def part1(rules, updates) do
    updates
      |> Enum.map(fn upd -> {upd, correct_order?(upd, rules)} end)
      |> Enum.filter(fn {_, violated_rules} -> Enum.empty?(violated_rules) end)
      |> Enum.map(fn { upd, _ } -> upd |> Enum.at(div(length(upd), 2)) |> String.to_integer() end)
      |> Enum.sum()
  end

  defp correct_order?(_, []), do: [] # no violated rules
  defp correct_order?(update, [rule = {n_before, n_after} | rules_rest]) do
    idx_before = Enum.find_index(update, fn p -> p == n_before end)
    idx_after  = Enum.find_index(update, fn p -> p == n_after end)
    cond do
      idx_before == nil or idx_after == nil ->
        correct_order?(update, rules_rest)
      idx_before > idx_after ->
        [ rule | correct_order?(update, rules_rest) ]
      true ->
        correct_order?(update, rules_rest)
    end
  end

  def part2(rules, updates) do
    updates
      |> Stream.map(fn upd -> {upd, relevant_rules(upd, rules)} end)
      |> Stream.map(fn { upd, relevant } -> {upd, relevant, correct_order?(upd, relevant)} end)
      |> Stream.filter(fn {_, _, violated_rules} -> not Enum.empty?(violated_rules) end)
      |> Stream.map(fn {upd, relevant, violated_rules} -> fix(upd, violated_rules, relevant) end)
      |> Stream.map(fn fixed -> fixed |> Enum.at(div(length(fixed), 2)) |> String.to_integer() end)
      |> Enum.sum()
  end

  defp relevant_rules(update, rules) do
    rules
      |> Stream.map(fn rule = {n_before, n_after} -> {rule, Enum.member?(update, n_before), Enum.member?(update, n_after)} end)
      |> Stream.filter(fn {_, before_in, after_in} -> before_in and after_in end)
      |> Enum.map(fn {rule, _, _} -> rule end)
  end

  defp fix(update, [], rules) do
    violated_rules = correct_order?(update, rules)
    case violated_rules do
      [] -> update
      _  -> fix(update, violated_rules, rules)
    end
  end

  defp fix(update, [{n_before, n_after} | violated_rules], rules) do
    idx_before = Enum.find_index(update, fn p -> p == n_before end)
    idx_after = Enum.find_index(update, fn p -> p == n_after end)
    if idx_before > idx_after do
      fixed_update = update
        |> List.delete_at(idx_before) # num before has larger idx, need to remove from there
        |> List.insert_at(idx_after, n_before) # add into the same place as num after is now - num after will move right
      fix(fixed_update, violated_rules, rules)
    else
      fix(update, violated_rules, rules)
    end
  end
end
