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
    0 -> {
      let #(a, b) = halve_string(number)
      a == b
    }
    _ -> False
  }
}

fn halve_string(subject: String) -> #(String, String) {
  let half_length = string.length(subject) / 2

  #(
    string.slice(subject, 0, half_length),
    string.slice(subject, half_length, half_length * 2),
  )
}

fn is_very_silly(number: String) -> Bool {
  list.range(1, to: string.length(number) / 2)
  |> list.filter(fn(chunksize) { string.length(number) % chunksize == 0 })
  |> list.map(split_into_unique_parts(number, into: _))
  |> list.any(fn(parts) { set.size(parts) == 1 })
}

fn split_into_unique_parts(
  subject: String,
  into number_of_parts: Int,
) -> set.Set(String) {
  string.to_graphemes(subject)
  |> list.sized_chunk(number_of_parts)
  |> list.map(string.join(_, with: ""))
  |> set.from_list
}
