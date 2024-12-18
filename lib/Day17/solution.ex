defmodule Day17 do
  defmodule Computer do
    defstruct a: 0, b: 0, c: 0
  end

  def readInput(raw) do
    [ reg_a_str, reg_b_str, reg_c_str, program_str ] = raw
      |> String.split("\n", trim: true)

    reg_a = read_reg(reg_a_str)
    reg_b = read_reg(reg_b_str)
    reg_c = read_reg(reg_c_str)
    program = String.slice(program_str, 9, String.length(program_str))
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    { %Computer{a: reg_a, b: reg_b, c: reg_c}, Arrays.new(program) }
  end

  defp read_reg(reg_str) do
    [_, reg_val_str] = Regex.run(~r/Register .: (\d+)/, reg_str)
    String.to_integer(reg_val_str)
  end

  def part1(computer, program) do
    run(computer, program, 0)
      |> Enum.filter(&(&1 != ""))
      |> Enum.join(",")
  end

  defp run(computer, program, pc) do
    if pc + 1 < Arrays.size(program) do # not trying to read after the end of the program
      instr = mk_instr(program[pc], program[pc+1])
      { changed_computer, instr_output, new_pc } = run_instr(computer, instr, pc)
      [ instr_output | run(changed_computer, program, new_pc) ]
    else
      []
    end
  end

  defp mk_instr(opcode, operand) do
    case opcode do
      0 -> { :adv, operand }
      1 -> { :bxl, operand }
      2 -> { :bst, operand }
      3 -> { :jnz, operand }
      4 -> { :bxc, operand }
      5 -> { :out, operand }
      6 -> { :bdv, operand }
      7 -> { :cdv, operand }
    end
  end

  defp run_instr(computer, { :adv, operand }, pc) do
    denominator = 2 ** (combo_operand(computer, operand))
    { %Computer{ computer | a: div(computer.a, denominator) }, "", pc + 2 }
  end

  defp run_instr(computer, { :bxl, operand }, pc) do
    { %Computer{ computer | b: Bitwise.bxor(computer.b, operand) }, "", pc + 2 }
  end

  defp run_instr(computer, { :bst, operand }, pc) do
    { %Computer{ computer | b: Integer.mod(combo_operand(computer, operand), 8) }, "", pc + 2 }
  end

  defp run_instr(computer, { :jnz, operand }, pc) do
    if computer.a != 0 do
      { computer, "", operand }
    else
      { computer, "", pc + 2 }
    end
  end

  defp run_instr(computer, { :bxc, _operand }, pc) do
    { %Computer{ computer | b: Bitwise.bxor(computer.b, computer.c) }, "", pc + 2 }
  end

  defp run_instr(computer, { :out, operand }, pc) do
    val = Integer.mod(combo_operand(computer, operand), 8)
    { computer, "#{val}", pc + 2 }
  end

  defp run_instr(computer, { :bdv, operand }, pc) do
    denominator = 2 ** (combo_operand(computer, operand))
    { %Computer{ computer | b: div(computer.a, denominator) }, "", pc + 2 }
  end

  defp run_instr(computer, { :cdv, operand }, pc) do
    denominator = 2 ** (combo_operand(computer, operand))
    { %Computer{ computer | c: div(computer.a, denominator) }, "", pc + 2 }
  end

  defp combo_operand(computer, operand) do
    cond do
      operand in 0..3 -> operand
      operand == 4    -> computer.a
      operand == 5    -> computer.b
      operand == 6    -> computer.c
    end
  end
end
