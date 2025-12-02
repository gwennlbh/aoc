import gleam/int
import gleam/list
import gleam/result
import gleam/set
import gleam/string
import utils

pub fn part_1() -> Int {
  utils.read_to_lines("../inputs/2.txt")
  |> list.first
  |> result.unwrap("")
  |> string.split(on: ",")
  |> list.flat_map(expand_range)
  |> list.filter(is_silly)
  |> list.map(int.parse)
  |> list.map(result.unwrap(_, 0))
  |> list.reduce(fn(acc, x) { acc + x })
  |> result.unwrap(0)
}

pub fn part_2() -> Int {
  utils.read_to_lines("../inputs/2.txt")
  |> list.first
  |> result.unwrap("")
  |> string.split(on: ",")
  |> list.flat_map(expand_range)
  |> list.filter(is_very_silly)
  |> list.map(int.parse)
  |> list.map(result.unwrap(_, 0))
  |> list.reduce(fn(acc, x) { acc + x })
  |> result.unwrap(0)
}

fn expand_range(range: String) -> List(String) {
  let stops =
    string.split(range, on: "-")
    |> list.map(int.parse)
    |> list.map(result.unwrap(_, 0))

  let start = list.first(stops) |> result.unwrap(0)
  let end = list.last(stops) |> result.unwrap(0)

  list.range(start, end) |> list.map(int.to_string)
}

fn is_silly(number: String) -> Bool {
  has_one_unique_part(number, chunks: 2)
}

fn is_very_silly(number: String) -> Bool {
  list.range(1, to: string.length(number) / 2)
  |> list.any(has_one_unique_part(number, chunks: _))
}

fn has_one_unique_part(subject: String, chunks number_of_chunks: Int) -> Bool {
  case string.length(subject) % number_of_chunks {
    0 ->
      string.to_graphemes(subject)
      |> list.sized_chunk(string.length(subject) / number_of_chunks)
      |> list.map(string.join(_, with: ""))
      |> set.from_list
      |> set.size
      == 1
    _ -> False
  }
}
