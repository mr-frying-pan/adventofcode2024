defmodule Day4.Solution do
  def readInput(raw) do
    String.split(raw)
      |> Enum.with_index()
      |> Enum.map(fn {row, r} ->
                      {String.graphemes(row) |> Enum.with_index(), r}
                  end)
  end

  def part1(sheet) do
    sheet
      |> Enum.map(fn {row, r} ->
                    row
                      |> Enum.map(fn {letter, c} ->
                                    count_xmas(letter, r, c, sheet)
                                  end)
                      |> Enum.sum()
                  end)
      |> Enum.sum()
  end

  defp directions() do
    %{
      :up         => {-1,  0},
      :up_right   => {-1,  1},
      :right      => { 0,  1},
      :down_right => { 1,  1},
      :down       => { 1,  0},
      :down_left  => { 1, -1},
      :left       => { 0, -1},
      :up_left    => {-1, -1},
    }
  end

  defp count_xmas("X", r, c, sheet) do
    Enum.map(directions(), fn {_dir_name, dir = {r_change, c_change}} ->
      check_direction(dir, "M", r + r_change, c + c_change, sheet) end)
      |> Enum.sum()
  end
  defp count_xmas(_, _, _, _), do: 0

  defp check_direction(_, "S", r, c, sheet) do
    if letter_in_sheet(sheet, r, c) == "S" do
      1
    else
      0
    end
  end

  defp check_direction(dir = {r_change, c_change}, letter, r, c, sheet) do
    if letter_in_sheet(sheet, r, c) == letter do
      check_direction(dir, next_letter(letter), r + r_change, c + c_change, sheet)
    else
      0
    end
  end

  defp letter_in_sheet(sheet, r, c) do
    try do
      { row, ^r } = Enum.at(sheet, r)
      if row do
        { letter, ^c } =Enum.at(row, c)
        letter
      end
    rescue
      MatchError -> nil
    end
  end

  defp next_letter(letter) do
    case letter do
      "M" -> "A"
      "A" -> "S"
    end
  end

  def part2(sheet) do
    sheet
      |> Enum.map(fn {row, r} when r >= 1 and r < length(row) - 1 -> # first and last rows will not have center grid cell
                        row
                          |> Enum.map(fn {_, c} when c >= 1 and c < length(row) - 1 -> # first and last cols will not have center grid cell
                                            has_shape(sheet, r, c)
                                          _ -> 0
                                      end)
                          |> Enum.sum()
                      _ -> 0
                  end)
      |> Enum.sum()
  end

  defp has_shape(sheet, r, c) do # r, c are coordinates of middle cell
    shapes = [
      [ # shape 1
        ["M", ".", "M"],
        [".", "A", "."],
        ["S", ".", "S"],
      ],
      [ # shape 2
        ["S", ".", "M"],
        [".", "A", "."],
        ["S", ".", "M"],
      ],
      [ # shape 3
        ["S", ".", "S"],
        [".", "A", "."],
        ["M", ".", "M"],
      ],
      [ # shape 4
        ["M", ".", "S"],
        [".", "A", "."],
        ["M", ".", "S"],
      ],
    ]

    grid_from_sheet = extract_grid_around(sheet, r, c)
    if Enum.any?(shapes, fn shape -> grid_match(shape, grid_from_sheet) end) do
      1
    else
      0
    end
  end

  defp extract_grid_around(sheet, r, c) do
    sheet
      |> Enum.slice((r-1)..(r+1))
      |> Enum.map(fn {row, _} -> row end)
      |> Enum.map(&(Enum.slice(&1, (c-1)..(c+1)) |> Enum.map(fn {letter, _} -> letter end)))
  end

  defp grid_match([], []), do: true
  defp grid_match([shape_row | shape_rest], [grid_row | grid_rest]) do
    row_match(shape_row, grid_row) && grid_match(shape_rest, grid_rest)
  end

  defp row_match([], []), do: true
  defp row_match([shape_letter | shape_row], [grid_letter | grid_row]) do
    if shape_letter == "." do
      row_match(shape_row, grid_row)
    else
      shape_letter == grid_letter && row_match(shape_row, grid_row)
    end
  end
end
