defmodule Day12 do
  def readInput(raw) do
    raw
      |> String.split()
  end

  def part1(plot) do
    [row | _] = plot
    max_r = length(plot)
    max_c = String.length(row)
    graph = build_graph(plot, 0, 0, max_r, max_c)

    find_areas_and_perimeters(graph)
      |> Enum.map(fn {area, perimeter} -> area * perimeter end)
      |> Enum.sum()
  end

  # finished last row
  defp build_graph(_, r, c, max_r, max_c) when r >= max_r - 1 and c >= max_c, do: %{}
  # passed the last col
  defp build_graph(plot, r, c, max_r, max_c) when c >= max_c, do: build_graph(plot, r + 1, 0, max_r, max_c)
  defp build_graph(plot, r, c, max_r, max_c) do
    [row_above, row, row_below] = custom_slice(plot, r-1, r+1)
    this = String.at(row, c)
    neighbours = %{
      {r, c + 1} => custom_at(row, c + 1),
      {r, c - 1} => custom_at(row, c - 1),
      {r - 1, c} => custom_at(row_above, c),
      {r + 1, c} => custom_at(row_below, c),
    } |> Map.filter(fn {_, val} -> val == this end)
      |> Map.keys()

    Map.put(build_graph(plot, r, c + 1, max_r, max_c), {r, c}, neighbours)
  end

  defp custom_at(nil, _), do: nil
  defp custom_at(str, at) when is_binary(str) and at < 0, do: nil
  defp custom_at(str, at) when is_binary(str), do: String.at(str, at)

  defp custom_slice(list, from, to) when from < 0, do: [nil | custom_slice(list, from + 1, to)]
  defp custom_slice(list, from, to) do
    custom_slice(list, 0, from, to)
  end

  # terminate slice
  defp custom_slice(_, idx, _, to) when to < idx, do: []
  # skip till from
  defp custom_slice([_ | list], idx, from, to) when idx < from, do: custom_slice(list, idx + 1, from, to)
  # list items run out first
  defp custom_slice([], idx, from, to), do: [nil | custom_slice([], idx + 1, from, to)]
  # taking what's needed
  defp custom_slice([item | list], idx, from, to)do
    [item | custom_slice(list, idx + 1, from, to)]
  end

  defp find_areas_and_perimeters(graph) do
    nodes = Map.keys(graph)
    case nodes do
      [] -> []
      _ ->
        { new_graph, area, perimeter } = find_area_and_perimeter(graph, [List.first(nodes)], 0, 0)
        [ { area, perimeter } | find_areas_and_perimeters(new_graph) ]
    end
  end

  defp find_area_and_perimeter(graph, [], area, perimeter), do: { graph, area, perimeter }
  defp find_area_and_perimeter(graph, [node | nodes], area, perimeter) do
    { neighbours, new_graph } = Map.pop(graph, node)
    case neighbours do
      nil -> find_area_and_perimeter(new_graph, nodes, area, perimeter) # already visited, no need to do anything
      _ -> find_area_and_perimeter(new_graph, nodes ++ neighbours, area + 1, perimeter + (4 - length(neighbours)))
    end
  end

  def part2(plot) do
    [row | _] = plot
    max_r = length(plot)
    max_c = String.length(row)
    graph = build_graph(plot, 0, 0, max_r, max_c)

    count_areas_and_sides(graph, graph)
      |> Enum.map(fn {area, sides} -> area * sides end)
      |> Enum.sum()
  end

  defp count_areas_and_sides(original_graph, graph) do
    nodes = Map.keys(graph)
    case nodes do
      [] -> []
      _ ->
        # number of sides seems to be equal to number of corners
        { new_graph, area, sides } = count_area_and_corners(original_graph, graph, [List.first(nodes)], 0, 0)
        [ { area, (if area == 1, do: 4, else: sides) } | count_areas_and_sides(original_graph, new_graph) ]
    end
  end

  defp count_area_and_corners(_, graph, [], area, corners), do: { graph, area, corners }
  defp count_area_and_corners(original_graph, graph, [node | nodes], area, corners) do
    { neighbours, new_graph } = Map.pop(graph, node)
    case neighbours do
      # nil - already visited before, no need to check again
      nil -> count_area_and_corners(original_graph, new_graph, nodes, area, corners)
        _ -> count_area_and_corners(original_graph, new_graph, nodes ++ neighbours, area + 1, corners + count_corners(original_graph, node, neighbours))
    end
  end

  defp count_corners(_, _, neighbours) when length(neighbours) == 1, do: 2
  defp count_corners(original_graph, node, neighbours) do
    outies(node, neighbours) + innies(original_graph, node, neighbours)
  end

  defp outies(_, neighbours) when length(neighbours) != 2, do: 0
  defp outies({r, c}, neighbours) do
    cond do
      {r, c + 1} in neighbours and {r + 1, c} in neighbours -> 1
      {r + 1, c} in neighbours and {r, c - 1} in neighbours -> 1
      {r, c - 1} in neighbours and {r - 1, c} in neighbours -> 1
      {r - 1, c} in neighbours and {r, c + 1} in neighbours -> 1
      true -> 0
    end
  end

  defp innies(original_graph, {r, c}, neighbours) do
    down_right = if {r, c + 1} in neighbours
                and {r + 1, c} in neighbours
                and not ({r + 1, c + 1} in Map.fetch!(original_graph, {r + 1, c})), do: 1, else: 0

    down_left  = if {r + 1, c} in neighbours
                and {r, c - 1} in neighbours
                and not ({r + 1, c - 1} in Map.fetch!(original_graph, {r, c - 1})), do: 1, else: 0

    up_left    = if {r, c - 1} in neighbours
                and {r - 1, c} in neighbours
                and not ({r - 1, c - 1} in Map.fetch!(original_graph, {r - 1, c})), do: 1, else: 0

    up_right   = if {r - 1, c} in neighbours
                and {r, c + 1} in neighbours
                and not ({r - 1, c + 1} in Map.fetch!(original_graph, {r, c + 1})), do: 1, else: 0

    down_right + down_left + up_left + up_right
  end
end
