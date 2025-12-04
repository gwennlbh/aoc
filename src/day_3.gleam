import gleam/int
import gleam/list
import gleam/result
import gleam/string
import utils

pub fn part_1() -> Int {
  utils.read_to_lines("../inputs/3.txt")
  |> list.map(batteries_of_bank)
  |> list.map(optimal_pair_joltage)
  |> int.sum
}

pub fn part_2() -> Int {
  utils.read_to_lines("../inputs/3.txt")
  |> list.map(batteries_of_bank)
  |> list.map(optimal_group_joltage(_, with: 12))
  |> int.sum
}

fn optimal_group_joltage(batteries: List(Int), with group_size: Int) {
  case group_size {
    0 -> 0
    1 -> batteries |> list.fold(0, int.max)
    n -> {
      let #(at, value) =
        batteries
        |> list.take(up_to: list.length(batteries) - n + 1)
        |> utils.argmax
        |> result.unwrap(#(0, 0))

      let rest = batteries |> list.drop(up_to: at + 1)

      echo n
      echo value
        * utils.whole_power(10, n-1)
        + optimal_group_joltage(rest, with: n - 1)
    }
  }
}

fn optimal_pair_joltage(batteries: List(Int)) {
  let #(first_battery_at, first_battery) =
    batteries
    |> utils.all_but_last
    |> utils.argmax
    |> result.unwrap(#(0, 0))

  let second_battery =
    batteries
    |> list.drop(up_to: first_battery_at + 1)
    |> list.reduce(int.max)
    |> result.unwrap(0)

  first_battery * 10 + second_battery
}

fn batteries_of_bank(bank: String) -> List(Int) {
  bank
  |> string.to_graphemes
  |> list.map(int.parse)
  |> list.map(result.unwrap(_, 0))
}
