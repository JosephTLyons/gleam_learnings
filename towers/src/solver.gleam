import gleam/bool
import gleam/list
import gleam/result
import towers

pub fn solve(pegs: towers.Pegs) {
  let assert Ok(peg) =
    pegs
    |> towers.get_state()
    |> list.at(0)

  let ring_count =
    peg
    |> list.length()

  pegs
  |> do_solve(ring_count, 0, 1, 2)
}

fn do_solve(
  pegs: towers.Pegs,
  n: Int,
  from: Int,
  to: Int,
  aux: Int,
) -> Result(towers.Pegs, towers.GameError) {
  use <- bool.guard(n == 0, Ok(pegs))
  use pegs <- result.try(do_solve(pegs, n - 1, from, aux, to))
  use pegs <- result.try(towers.move_ring(pegs, from, to))
  use pegs <- result.try(do_solve(pegs, n - 1, aux, to, from))
  Ok(pegs)
}
