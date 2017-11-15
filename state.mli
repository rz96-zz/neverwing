open Board
(*open Command*)

(*Type board represents the coordinate board with objects in it*)
type board = Board.board

(*Type state represents the current game state, including information
  such as monster locations, HP levels, rows until next boss, and game over*)
type state

(*[update_state] changes the state according to the command that was given
and moving the rows of monsters down by one each iteration*)
val update_state : Command.command -> state -> state
(*every command, you should also update the hp of the monsters
  and of the sprite itself*)
