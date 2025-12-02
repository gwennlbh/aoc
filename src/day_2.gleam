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
  case string.length(number) % 2 {
    1 -> False
    0 -> number_of_unique_parts(number, into: 2) == 1
    _ -> False
  }
}

fn is_very_silly(number: String) -> Bool {
  list.range(1, to: string.length(number) / 2)
  |> list.filter(fn(chunksize) { string.length(number) % chunksize == 0 })
  |> list.map(number_of_unique_parts(number, into: _))
  |> list.any(fn(parts) { parts == 1 })
}

fn number_of_unique_parts(subject: String, into number_of_parts: Int) -> Int {
  let s =
    string.to_graphemes(subject)
    |> list.sized_chunk(string.length(subject) / number_of_parts)
    |> list.map(string.join(_, with: ""))
    |> set.from_list

//   echo s |> set.to_list

  s |> set.size
}
