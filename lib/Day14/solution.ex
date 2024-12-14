defmodule Day14 do
  def readInput(raw) do
    raw
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split/1)
      |> Enum.map(fn [pos_str, vel_str] ->
          [_, p_c_str, p_r_str] = Regex.run(~r/p=(\d+),(\d+)/, pos_str)
          [_, v_c_str, v_r_str] = Regex.run(~r/v=(-?\d+),(-?\d+)/, vel_str)
          %{
            pos: { String.to_integer(p_r_str), String.to_integer(p_c_str) },
            vel: { String.to_integer(v_r_str), String.to_integer(v_c_str) }
          }
        end)
  end

  def part1(robots, rs, cs, seconds) do
    quadrants = robots
      |> Enum.map(fn %{pos: {r, c}, vel: {v_r, v_c}} -> { pos_rem(r + v_r * seconds, rs), pos_rem(c + v_c * seconds, cs) } end)
      |> Enum.group_by(fn {r, c} ->
          middle_r = div(rs, 2) # don't need + 1 because 0 based
          middle_c = div(cs, 2) # don't need + 1 because 0 based
          cond do
            r < middle_r and c < middle_c -> :top_left
            r < middle_r and c > middle_c -> :top_right
            r > middle_r and c < middle_c -> :bottom_left
            r > middle_r and c > middle_c -> :bottom_right
            true -> :trash
          end
        end)

    length(quadrants.top_left) * length(quadrants.top_right) * length(quadrants.bottom_left) * length(quadrants.bottom_right)
  end

  def part2(robots, rs, cs) do
    draw_robots(robots, rs, cs, 0)
  end

  defp draw_robots(robots, rs, cs, second) do
    draw_position(robots, rs, cs, second)
    if second < 10000 do
      next_robots = next_position(robots, rs, cs)
      draw_robots(next_robots, rs, cs, second + 1)
    end
  end

  defp draw_position(robots, rs, cs, second) do
    image = robots
      |> Enum.reduce(Image.new!(cs, rs), fn %{pos: {r, c}}, img -> Image.Draw.point!(img, c, r, color: :white) end)

    Image.write!(image, "lib/Day14/imgs/#{second}.png", compression: 1, effort: 1)
  end

  defp next_position(robots, rs, cs) do
    robots
      |> Stream.map(fn %{pos: {r, c}, vel: vel = {v_r, v_c}} ->
          %{
            pos: {pos_rem(r + v_r, rs), pos_rem(c + v_c, cs)},
            vel: vel
          }
        end)
  end

  defp pos_rem(dividend, divisor) do
    remd = rem(dividend, divisor)
    if remd < 0 do
      remd + divisor
    else
      remd
    end
  end
end
