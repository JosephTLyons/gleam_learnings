import gleam/list
import gleeunit
import gleeunit/should
import towers
import solver

pub fn main() {
  gleeunit.main()
}

pub fn solve_test() {
  list.range(1, 10)
  |> list.each(fn(size) {
    let assert Ok(pegs) =
      towers.initialize(size)
      |> solver.solve()

    pegs
    |> towers.get_state()
    |> should.equal([[], list.range(1, size), []])
  })
}
