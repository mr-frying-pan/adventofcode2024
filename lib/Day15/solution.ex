defmodule Day15 do
  def readInput(raw) do
    {map, moves} = raw
      |> String.split("\n")
      |> Enum.split_while(&(&1 != ""))
    {
      map |> Enum.map(&(String.graphemes(&1)) |> Arrays.new()) |> Arrays.new(),
      Enum.filter(moves, &(&1 != "")) |> Enum.flat_map(&String.graphemes/1)
    }
  end

  def part1(map, moves) do
    { start_r, start_c } = find_start_position(map)
    final_map = move_robot(map, start_r, start_c, moves)
    get_box_coords(final_map, "O")
      |> Enum.map(fn {r, c} -> 100 * r + c end)
      |> Enum.sum()
  end

  defp find_start_position(map) do
    find_start_position(map, 1, Arrays.size(map[0])) # skip first row, wall anyway
  end

  defp find_start_position(map, r, max_c) do
    find_start_position(map, r, 1, max_c) # skip first col, wall anyway
  end

  defp find_start_position(map, r, max_c, max_c), do: find_start_position(map, r + 1, 1, max_c)
  defp find_start_position(map, r, c, max_c) do
    pos = map[r][c]
    if pos == "@" do
      {r, c}
    else
      find_start_position(map, r, c + 1, max_c)
    end
  end

  defp move_robot(map, _, _, []), do: map
  defp move_robot(map, r, c, [move | moves]) do
    {moved_map, new_r, new_c} = push(map, "@", r, c, move)
    if r != new_r or c != new_c do
      new_map = set(moved_map, r, c, ".") # remove old robot position
      move_robot(new_map, new_r, new_c, moves)
    else
      move_robot(moved_map, new_r, new_c, moves)
    end
  end

  defp push(map, who, r, c, move) do
    {dr, dc} = direction(move)
    destination = map[r + dr][c + dc]
    case destination do
      "#" -> {map, r, c} # wall, not going anywhere
      "." ->             # empty space, moving in
        new_map = set(map, r + dr, c + dc, who)
        {new_map, r + dr, c + dc}
      "O" ->             # box, need to push to move in
        {box_pushed_map, new_box_r, new_box_c} = push(map, "O", r + dr, c + dc, move)
        if new_box_r != r + dr or new_box_c != c + dc do
          new_map = set(box_pushed_map, r + dr, c + dc, who)
          { new_map, r + dr, c + dc }
        else
          { map, r, c}
        end
    end
  end

  defp direction(dir) do
    case dir do
      "^" -> {-1,  0}
      ">" -> { 0,  1}
      "v" -> { 1,  0}
      "<" -> { 0, -1}
    end
  end

  defp set(map, r, c, val) do
    Arrays.replace(map, r, Arrays.replace(map[r], c, val))
  end

  defp get_box_coords(map, box) do
    Enum.concat(get_box_coords(map, 0, Arrays.size(map), box))
  end
  defp get_box_coords(_, max_r, max_r, _), do: []
  defp get_box_coords(map, r, max_r, box) do
    row = map[r]
    [ get_box_coords(row, r, 0, Arrays.size(row), box) | get_box_coords(map, r + 1, max_r, box) ]
  end

  defp get_box_coords(_, _, max_c, max_c, _), do: []
  defp get_box_coords(row, r, c, max_c, box) do
    pos = row[c]
    case pos do
      ^box -> [{r, c} | get_box_coords(row, r, c + 1, max_c, box)]
      _   -> get_box_coords(row, r, c + 1, max_c, box)
    end
  end

  defp print(map) do
    for r <- 0..(Arrays.size(map) - 1) do
      row = map[r]
      for c <- 0..(Arrays.size(row) - 1) do
        IO.write(row[c])
      end
      IO.write("\n")
    end
  end

  def part2(map, moves) do
    { start_r, start_c } = find_start_position(map)
    final_map = move_robot2(map, start_r, start_c, moves)
    get_box_coords(final_map, "[")
      |> Enum.map(fn {r, c} -> 100 * r + c end)
      |> Enum.sum()
  end

  defp move_robot2(map, _, _, []), do: map
  defp move_robot2(map, r, c, [move | moves]) do
    {moved_map, new_r, new_c} = push2(map, r, c, move)
    if r != new_r or c != new_c do
      new_map = moved_map
        |> set(r, c, ".") # remove old robot position
      move_robot2(new_map, new_r, new_c, moves)
    else
      move_robot2(moved_map, new_r, new_c, moves)
    end
  end

  defp push2(map, r, c, move) do
    {dr, dc} = direction(move)
    destination = map[r + dr][c + dc]
    case destination do
      "#" -> {map, r, c} # wall, not going anywhere
      "." ->             # empty space, moving in
        new_map = set(map, r + dr, c + dc, "@")
        {new_map, r + dr, c + dc}
      "[" ->
        { box_pushed_map, new_r, new_c } = push_box(map, r + dr, c + dc, move)
        if new_r != r + dr or new_c != c + dc do
          new_map = set(box_pushed_map, r + dr, c + dc, "@")
          { new_map, r + dr, c + dc }
        else
          { map, r, c }
        end
      "]" ->
        # left side of the box has to be passed
        { box_pushed_map, new_r, new_c } = push_box(map, r + dr, c + dc - 1, move)
        if new_r != r + dr or new_c != c + dc - 1 do
          new_map = set(box_pushed_map, r + dr, c + dc, "@")
          { new_map, r + dr, c + dc }
        else
          { map, r, c }
        end
    end
  end

  # (r, c) - location of the left side of the box
  # returns location of left side of the box after the push
  defp push_box(map, r, c, move) do
    case move do
      "^" -> push_box_up(map, r, c)
      ">" -> push_box_right(map, r, c)
      "v" -> push_box_down(map, r, c)
      "<" -> push_box_left(map, r, c)
    end
  end

  defp push_box_up(map, r, c), do: push_box_vertically(map, r, c, -1)
  defp push_box_down(map, r, c), do: push_box_vertically(map, r, c, 1)

  defp push_box_vertically(map, r, c, d) do
    left_dest = map[r+d][c]
    right_dest = map[r+d][c+1]
    cond do
      left_dest == "#" or right_dest == "#" -> { map, r, c }
      left_dest == "." and right_dest == "." ->
        new_map = map |> set(r+d, c, "[") |> set(r+d, c+1, "]")
          |> set(r, c, ".") |> set(r, c+1, ".")
        { new_map, r+d, c }
      left_dest == "[" and right_dest == "]" ->
        { box_pushed_map, box_r, _box_c } = push_box_vertically(map, r+d, c, d)
        if box_r != r+d do
          new_map = box_pushed_map |> set(r+d, c, "[") |> set(r+d, c+1, "]")
            |> set(r, c, ".") |> set(r, c+1, ".")
          { new_map, r+d, c }
        else
          { map, r, c } # could not push - do not change anything
        end
      left_dest == "]" and right_dest == "." ->
        { box_pushed_map, box_r, _box_c } = push_box_vertically(map, r+d, c-1, d)
        if box_r != r+d do
          new_map = box_pushed_map |> set(r+d, c, "[") |> set(r+d, c+1, "]")
            |> set(r, c, ".") |> set(r, c+1, ".")
          { new_map, r+d, c }
        else
          { map, r, c } # could not push - do not change anything
        end
      left_dest == "." and right_dest == "[" ->
        { box_pushed_map, box_r, _box_c } = push_box_vertically(map, r+d, c+1, d)
        if box_r != r+d do
          new_map = box_pushed_map |> set(r+d, c, "[") |> set(r+d, c+1, "]")
            |> set(r, c, ".") |> set(r, c+1, ".")
          { new_map, r+d, c }
        else
          { map, r, c } # could not push - do not change anything
        end
      left_dest == "]" and right_dest == "[" ->
        { left_box_pushed, lbox_r, _lbox_c } = push_box_vertically(map, r+d, c-1, d)
        { both_boxes_pushed, rbox_r, _rbox_c } = push_box_vertically(left_box_pushed, r+d, c+1, d)
        if lbox_r != r+d and rbox_r != r+d do
          new_map = both_boxes_pushed |> set(r+d, c, "[") |> set(r+d, c+1, "]")
            |> set(r, c, ".") |> set(r, c+1, ".")
          { new_map, r+d, c }
        else
          { map, r, c }
        end
    end
  end

  defp push_box_right(map, r, c) do
    right_dest = map[r][c+2]
    case right_dest do
      "#" -> {map, r, c}
      "." ->
        new_map = map |> set(r, c+1, "[") |> set(r, c+2, "]")
        { new_map, r, c+1 }
      "[" ->
        { box_pushed_map, _box_r, box_c } = push_box_right(map, r, c+2)
        if box_c != c+2 do
          new_map = box_pushed_map |> set(r, c+1, "[") |> set(r, c+2, "]")
          { new_map, r, c+1 }
        else
          { map, r, c }
        end
    end
  end

  defp push_box_left(map, r, c) do
    left_dest = map[r][c-1]
    case left_dest do
      "#" -> { map, r, c }
      "." ->
        new_map = map |> set(r, c-1, "[") |> set(r, c, "]")
        { new_map, r, c-1 }
      "]" ->
        { box_pushed_map, _box_r, box_c } = push_box_left(map, r, c-2)
        if box_c != c-2 do
          new_map = box_pushed_map |> set(r, c-1, "[") |> set(r, c, "]")
          { new_map, r, c-1 }
        else
          { map, r, c }
        end
    end
  end
end
