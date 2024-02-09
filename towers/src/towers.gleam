import gleam/bool
import gleam/io
import gleam/list
import gleam/result

pub fn main() {
  let items =
    ["dog", "cat", "mouse", "man", "boy"]
    |> list.repeat(10)
    |> list.flatten()
    |> list.shuffle()

  items
  |> list.unique()
  |> print_list()
}

pub fn print_list(items: List(String)) {
  case items {
    [] -> Nil
    [first, ..rest] -> {
      io.println(first)
      print_list(rest)
    }
  }
}

pub opaque type Pegs {
  Pegs(state: List(List(Int)))
}

pub type GameError {
  InvalidPeg
  NoRingToMove
  BiggerRingOnSmallerRing
}

pub fn initialize(n: Int) -> Pegs {
  Pegs(state: [list.range(1, n), [], []])
}

pub fn get_state(pegs: Pegs) -> List(List(Int)) {
  pegs.state
}

pub fn move_ring(pegs: Pegs, from: Int, to: Int) -> Result(Pegs, GameError) {
  use from_peg <- result.try(get_peg(pegs, from))
  use to_peg <- result.try(get_peg(pegs, to))
  use #(from_ring, from_rest) <- result.try(
    from_peg
    |> list.pop(fn(_) { True })
    |> result.map_error(fn(_) { NoRingToMove }),
  )
  let from_ring_is_smaller =
    to_peg
    |> list.first()
    |> result.map(fn(to_ring) { from_ring < to_ring })
    |> result.unwrap(True)
  use <- bool.guard(!from_ring_is_smaller, Error(BiggerRingOnSmallerRing))
  let to_peg = [from_ring, ..to_peg]
  use pegs <- result.try(update_state(pegs, from, from_rest))
  use pegs <- result.try(update_state(pegs, to, to_peg))
  Ok(pegs)
}

pub fn get_peg(pegs: Pegs, peg_number: Int) -> Result(List(Int), GameError) {
  pegs.state
  |> list.at(peg_number)
  |> result.map_error(fn(_) { InvalidPeg })
}

pub fn update_state(
  pegs: Pegs,
  peg_number: Int,
  peg: List(Int),
) -> Result(Pegs, GameError) {
  use <- bool.guard(peg_number >= list.length(pegs.state), Error(InvalidPeg))
  let new_state =
    pegs.state
    |> list.index_map(fn(existing_peg, i) {
      case i == peg_number {
        True -> peg
        False -> existing_peg
      }
    })
  Ok(Pegs(state: new_state))
}
