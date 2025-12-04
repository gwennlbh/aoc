import gleam/option
import gleam/list
import gleam/result
import gleam/string
import utils

pub fn part_1() {
  utils.read_to_lines("../inputs/4.txt")
  |> lines_to_matrix
  |> accessible_rolls
  |> list.length
}

pub fn lines_to_matrix(lines: List(String)) -> List(List(Bool)) {
  lines
  |> list.map(string.to_graphemes)
  |> list.map(
    list.map(_, fn(char) {
      case char {
        "@" -> True
        _ -> False
      }
    }),
  )
}

pub fn accessible_rolls(cells: List(List(Bool))) -> List(#(Int, Int)) {
  let matrix =
    cells
    |> list.map(utils.index_pairs)
    |> utils.index_pairs
    |> list.fold([], fn(acc, cur) {
      let #(i, row) = cur

      row
      |> list.map(fn(pair) {
        let #(j, cell) = pair
        #(i, j, cell)
      })
      |> list.append(acc, _)
    })

  let i_range = list.range(0, list.length(cells) - 1)
  let j_range =
    list.range(0, list.length(cells |> list.first |> result.unwrap([])) - 1)

  i_range
  |> list.flat_map(fn(i) {
    j_range
    |> list.map(fn(j) { #(i, j) })
  })
  |> list.map(fn(ij) {
    let #(i, j) = ij

    #(i, j, case at(matrix, i, j) {
      False -> False
      True -> 
        [
          at(matrix, i - 1, j - 1),
          at(matrix, i - 1, j),
          at(matrix, i - 1, j + 1),
          at(matrix, i, j - 1),
          //   at(matrix, i, j),
          at(matrix, i, j + 1),
          at(matrix, i + 1, j - 1),
          at(matrix, i + 1, j),
          at(matrix, i + 1, j + 1),
        ]
        |> list.filter(fn(has_roll) { has_roll })
        |> list.length < 4
    })
  })
  |> list.filter(fn(item) {
    let #(_, _, accessible) = item
    accessible
  })
  |> list.map(fn(item) {
    let #(i, j, _) = item
    #(i, j)
  })
}

fn at(cells: List(#(Int, Int, Bool)), i: Int, j: Int) -> Bool {
  let #(_, _, value) =
    cells
    |> list.find(fn(element) {
      let #(el_i, el_j, _) = element

      el_i == i && el_j == j
    })
    |> result.unwrap(#(0, 0, False))

  value
}
