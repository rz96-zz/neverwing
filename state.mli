open Board
(*open Command*)


type board = Board.board (*state *)

type state

(*[update_state] changes the state according to the command that was given
  and moving the rows of monsters down by one each iteration *)
val update_state : Command.command -> state -> state
(*every command, you should also update the hp of the monsters
  and of the sprite itself*)
