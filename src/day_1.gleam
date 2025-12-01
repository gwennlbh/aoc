import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile
import utils

const initial_position = 50

const dial_size = 100

pub fn part_1() -> Int {
  utils.read_to_lines("../inputs/1.txt")
  |> list.map(parse_instruction)
  |> list.filter(is_valid)
  |> list.fold(#(initial_position, 0), fn(state, instruction) {
    let #(position, count) = state

    case apply_instruction(position, instruction) {
      0 -> #(0, count + 1)
      new_position -> #(new_position, count)
    }
  })
  |> utils.second
}

pub fn part_2() -> Int {
  utils.read_to_lines("../inputs/1.txt")
  |> list.map(parse_instruction)
  |> list.filter(is_valid)
  // |> list.take(50)
  |> list.fold(#(initial_position, 0), fn(state, instruction) {
    let #(position, count) = state

    #(
      apply_instruction(position, instruction),
      count + dial_overflows(position, instruction),
    )
  })
  |> utils.second
}

type Instruction {
  Left(Int)
  Right(Int)
  Unknown
}

fn is_valid(instruction: Instruction) -> Bool {
  case instruction {
    Unknown -> False
    _ -> True
  }
}

fn dial_overflows(position: Int, instruction: Instruction) -> Int {
  case instruction {
    Left(stops) -> position - stops
    Right(stops) -> position + stops
    Unknown -> 0
  }
  |> int.floor_divide(by: dial_size)
  |> result.unwrap(0)
  |> int.absolute_value
}

fn apply_instruction(position: Int, instruction: Instruction) -> Int {
  case instruction {
    Left(stops) -> position - stops
    Right(stops) -> position + stops
    Unknown -> 0
  }
  |> int.modulo(by: dial_size)
  |> result.unwrap(0)
}

fn parse_instruction(instruction: String) -> Instruction {
  let op = string.slice(instruction, 0, 1)

  let arg =
    string.drop_start(instruction, 1)
    |> int.parse

  case op, arg {
    "L", Ok(number) -> Left(number)
    "R", Ok(number) -> Right(number)
    _, _ -> Unknown
  }
}
