import gleam/erlang
import gleam/int
import gleam/io
import gleam/result
import gleam/string
import towers

// Identify win
pub fn main() {
  // Ask how many rings
  play(towers.initialize(3))
}

fn play(pegs: towers.Pegs) -> Result(Nil, Nil) {
  io.println("")
  towers.print(pegs)
  // Handle - shouldn't end game
  use from <- result.try(get_integer_input("from: "))
  // Handle - shouldn't end game
  use to <- result.try(get_integer_input("to: "))
  // Handle - shouldn't end game
  use pegs <- result.try(
    pegs
    |> towers.move_ring(from, to)
    |> result.nil_error,
  )

  play(pegs)
}

fn get_integer_input(prompt: String) -> Result(Int, Nil) {
  erlang.get_line(prompt)
  |> result.map(fn(text) {
    text
    |> string.trim_right
    |> int.parse
  })
  |> result.nil_error
  |> result.flatten
}
