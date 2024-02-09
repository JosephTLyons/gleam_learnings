import gleeunit
import gleeunit/should
import towers

pub fn main() {
  gleeunit.main()
}

pub fn initial_state_test() {
  towers.initialize(8)
  |> towers.get_state()
  |> should.equal([[1, 2, 3, 4, 5, 6, 7, 8], [], []])
}

pub fn move_from_invalid_peg_test() {
  towers.initialize(8)
  |> towers.move_ring(-1, 0)
  |> should.equal(Error(towers.InvalidPeg))

  towers.initialize(8)
  |> towers.move_ring(3, 0)
  |> should.equal(Error(towers.InvalidPeg))
}

pub fn move_to_invalid_peg_test() {
  towers.initialize(8)
  |> towers.move_ring(0, -1)
  |> should.equal(Error(towers.InvalidPeg))

  towers.initialize(8)
  |> towers.move_ring(0, 3)
  |> should.equal(Error(towers.InvalidPeg))
}

pub fn move_ring_test() {
  let assert Ok(pegs) =
    towers.initialize(8)
    |> towers.move_ring(0, 1)

  pegs
  |> towers.get_state()
  |> should.equal([[2, 3, 4, 5, 6, 7, 8], [1], []])

  let assert Error(towers.BiggerRingOnSmallerRing) =
    pegs
    |> towers.move_ring(0, 1)
}
