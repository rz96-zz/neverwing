open Board
open Sprite
open Command

(*Type board represents the coordinate board with objects in it*)
type board = Board.board

type phase =
  |Start
  |Active
  |End
(*Type state represents the current game state, including information
  such as monster locations, HP levels, rows until next boss, and game over
  type state = {
    bgd: sprite;
    context: Dom_html.canvasRenderingContext2D Js.t;
    mutable score: int;
    mutable game_over: bool;
  }*)

type state = {
  mutable board : (obj option) list list;
  mutable control : control;
  mutable player: obj option;
  mutable projectile_list: ((int * int) * obj option) list;
  mutable mons_list: (obj option) list;
  mutable score : int;
  mutable phase : phase
}

(*[update_state] changes the state according to the command that was given
and moving the rows of monsters down by one each iteration*)
(* val update_state : Command.command -> state -> state *)
(*every command, you should also update the hp of the monsters
  and of the sprite itself *)

(*val update_state : Dom_html.canvasElement Js.t
  -> unit*)


val move_player: state -> player -> unit

val make_state: int -> int -> state

val draw_state: Dom_html.canvasRenderingContext2D Js.t -> state -> unit

val update_objs_loop: state -> unit
