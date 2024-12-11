defmodule Day6 do
  defmodule AreaMap do
    defstruct map: [], rows: 0, cols: 0
  end

  def readInput(raw) do
    map = [row | _] = raw
      |> String.split("\n")
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&String.graphemes/1)

    %AreaMap{map: map, rows: length(map), cols: length(row)}
  end

  defp directions() do
    %{
      "^" => {-1,  0},
      ">" => { 0,  1},
      "v" => { 1,  0},
      "<" => { 0, -1}
    }
  end

  defp direction(dir) do
    Map.fetch!(directions(), dir)
  end

  def part1(map) do
    { start_r, start_c, start_dir } = find_start_position(map)

    walk(map, start_r, start_c, direction(start_dir), 0)
  end

  defp find_start_position(%AreaMap{map: map}) do
    find_start_row(map, 0)
  end

  defp find_start_row([row | map], row_idx) do
    { col_idx, dir } = find_start_col(row, 0)
    if col_idx do
      { row_idx, col_idx, dir }
    else
      find_start_row(map, row_idx + 1)
    end
  end

  defp find_start_col([], _), do: { nil, nil }
  defp find_start_col([p | col], col_idx) do
    if p in Map.keys(directions()) do
      { col_idx, p }
    else
      find_start_col(col, col_idx + 1)
    end
  end

  defp walk(map, r, c, dir = {r_inc, c_inc}, visited_positions) do
    if out_of_map(map, r, c) do
      visited_positions
    else
      current_pos = map.map |> Enum.at(r) |> Enum.at(c)

      case current_pos do
        "." -> # new position
          updated_map = mark_visited(map, r, c)
          walk(updated_map, r + r_inc, c + c_inc, dir, visited_positions + 1)
        "X" -> # previously visited position
          walk(map, r + r_inc, c + c_inc, dir, visited_positions)
        "#" -> # obstacle - go back and turn right
          walk(map, r - r_inc, c - c_inc, turn_right(dir), visited_positions)
        _ -> # realistically - starting guard position. Same as new position
          updated_map = mark_visited(map, r, c)
          walk(updated_map, r + r_inc, c + c_inc, dir, visited_positions + 1)
      end
    end
  end

  defp out_of_map(%AreaMap{rows: rs, cols: cs}, r, c) do
    r < 0 or r >= rs or c < 0 or c >= cs
  end

  defp mark_visited(map_struct = %AreaMap{map: map}, r, c) do
    current_row = Enum.at(map, r)
    updated_row = current_row
      |> List.replace_at(c, "X")
    updated_map = map
      |> List.replace_at(r, updated_row)
    %AreaMap{ map_struct | map: updated_map }
  end

  defp turn_right(dir) do
    cond do
      dir == direction("^") -> direction(">")
      dir == direction(">") -> direction("v")
      dir == direction("v") -> direction("<")
      dir == direction("<") -> direction("^")
    end
  end

  def part2(map) do
    { start_r, start_c, start_dir } = find_start_position(map)

     walk2(map, start_r, start_c, start_dir, 0)
  end

  defp walk2(map, r, c, dir, loops) do
    if out_of_map(map, r, c) do
      loops
    else
      current_pos = map.map |> Enum.at(r) |> Enum.at(c)

      { r_inc, c_inc } = direction(dir)

      loop_possible = look_right(map, r, c, dir)

      case current_pos do
        "." -> # new position
          updated_map = mark_visited2(map, r, c, dir)
          walk2(updated_map, r + r_inc, c + c_inc, dir)
        "#" -> # obstacle - go back and turn right
          walk2(map, r - r_inc, c - c_inc, turn_right2(dir))
        _ -> # previously visited position
          updated_map = mark_visited(map, r, c, dir)
          walk2(map, r + r_inc, c + c_inc, dir)
      end
    end
  end
end
