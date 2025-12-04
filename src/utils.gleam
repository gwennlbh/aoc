import gleam/bool
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn first(value: #(a, b)) -> a {
  let #(result, _) = value
  result
}

pub fn second(value: #(a, b)) -> b {
  let #(_, result) = value
  result
}

pub fn read_to_lines(at path: String) -> List(String) {
  simplifile.read(path)
  |> result.unwrap("")
  |> string.split(on: "\n")
  |> list.map(string.trim)
  |> list.filter(fn(line) { !string.is_empty(line) })
}

pub fn index_pairs(subject: List(a)) -> List(#(Int, a)) {
  subject |> list.index_map(fn(x, i) { #(i, x) })
}

pub fn argmax(subject: List(Int)) -> Result(#(Int, Int), Nil) {
  subject
  |> index_pairs
  |> list.reduce(fn(current_max, item) {
    let #(_, max) = current_max
    let #(_, value) = item

    case value > max {
      True -> item
      False -> current_max
    }
  })
}

pub fn all_but_last(subject: List(a)) -> List(a) {
  subject |> list.take(up_to: list.length(subject) - 1)
}

pub fn whole_power(base: Int, exponent: Int) -> Int {
  case exponent {
    0 -> 1
    n -> base * whole_power(base, n - 1)
  }
}
