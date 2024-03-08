import gleam/bool
import gleam/io
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub opaque type Pegs {
  Pegs(state: List(List(Int)))
}

pub type GameStatus {
  Playing(pegs: Pegs)
  Won
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
  let from_ring_is_bigger =
    to_peg
    |> list.first()
    |> result.map(fn(to_ring) { from_ring > to_ring })
    |> result.unwrap(False)
  use <- bool.guard(from_ring_is_bigger, Error(BiggerRingOnSmallerRing))
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
  new_peg: List(Int),
) -> Result(Pegs, GameError) {
  use <- bool.guard(peg_number >= list.length(pegs.state), Error(InvalidPeg))
  let new_state =
    pegs.state
    |> list.index_map(fn(existing_peg, i) {
      case i == peg_number {
        True -> new_peg
        False -> existing_peg
      }
    })
  Ok(Pegs(state: new_state))
}

pub fn print(pegs: Pegs) -> Result(Nil, Nil) {
  use lines <- result.try(get_print_lines(pegs))
  let lines =
    lines
    |> string.join("\n")
  io.println(lines)
  Ok(Nil)
}

pub fn get_print_lines(pegs: Pegs) -> Result(List(String), Nil) {
  do_get_print_lines(pegs.state, [])
}

fn do_get_print_lines(
  items: List(List(Int)),
  acc: List(String),
) -> Result(List(String), Nil) {
  case items {
    [] -> Ok(acc)
    [peg, ..pegs] -> {
      let peg_string =
        peg
        // Remove this by fixing how we store rings in the pegs (use queue)
        |> list.reverse
        |> list.map(int.to_string)
        |> string.join(" ")
      let acc =
        acc
        |> list.append([peg_string])
      do_get_print_lines(pegs, acc)
    }
  }
}
