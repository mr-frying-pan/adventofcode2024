defmodule Day13 do
  defmodule Machine do
    defstruct a: {0, 0}, b: {0, 0}, prize: {0, 0}
  end

  def readInput(raw) do
    raw
      |> String.split("\n", trim: true)
      |> Enum.chunk_every(3)
      |> Enum.map(fn [btn_a_str, btn_b_str, prize_str] ->
            [_, xa, ya] = Regex.run(~r/Button A: X\+(\d+), Y\+(\d+)/, btn_a_str)
            [_, xb, yb] = Regex.run(~r/Button B: X\+(\d+), Y\+(\d+)/, btn_b_str)
            [_, xp, yp] = Regex.run(~r/Prize: X=(\d+), Y=(\d+)/, prize_str)

            %Machine{
              a: {String.to_integer(xa), String.to_integer(ya)},
              b: {String.to_integer(xb), String.to_integer(yb)},
              prize: {String.to_integer(xp), String.to_integer(yp)}
            }
        end)
  end

  def part1(machines) do
    machines
      |> Enum.map(&get_a_b_counts/1)
  end

  @doc """
  Interpreting all values as vectors.
  Then calculating prize vector coordinates in terms of vectors A and B.
  """
  defp get_a_b_counts(%Machine{a: {xa, ya}, b: {xb, yb}, prize: {xp, yp}}) do
    # According to https://ocw.mit.edu/courses/16-07-dynamics-fall-2009/66b42ce6c35f2757ad11dc0a6e2b2896_MIT16_07F09_Lec03.pdf
    # page 10, equation 7

    len_a = vector_length(xa, ya)
    len_b = vector_length(xb, yb)
    # cos(theta_1_1)
    cos_angle_a_to_x = xa / len_a
    # cos(theta_1_2)
    cos_angle_a_to_y = ya / len_a

    # cos(theta_2_1)
    cos_angle_b_to_x = xb / len_b
    # cos(theta_2_2)
    cos_angle_b_to_y = yb / len_b

    %{
      a: {xa, ya}, len_a: len_a,
      b: {xb, yb}, len_b: len_b,
      cos_angle_a_to_x: cos_angle_a_to_x,
      cos_angle_a_to_y: cos_angle_a_to_y,
      cos_angle_b_to_x: cos_angle_b_to_x,
      cos_angle_b_to_y: cos_angle_b_to_y,
      prize: {xp, yp},
      new_prize: {
        xp * xa + yp * ya,
        xp * xb + yp * yb,
      }
    }
  end

  defp vector_length(x, y) do
    :math.sqrt(x**2 + y**2)
  end
end
