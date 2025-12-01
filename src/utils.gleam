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
}
