pub fn first(value: #(a, b)) -> a {
  let #(result, _) = value
  result
}

pub fn second(value: #(a, b)) -> b {
  let #(_, result) = value
  result
}
