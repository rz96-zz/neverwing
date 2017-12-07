open Board
open Command

(*Type board represents the coordinate board with objects in it*)
type board = Board.board

(*Type phase represents the phase the current game is in*)
type phase =
  |Start
  |Active
  |End

(*Type state represents the game state which consists of the game board
  user input (control), the player, lists of everything on the board (monsters
  and projectiles), score, game phase, messages to display to the user, and
  various counters to signify certain game features and actions*)
type state = {
  mutable board : (obj option) list list;
  mutable control : control;
  mutable player: obj option;
  mutable projectile_list: obj option list;
  mutable mons_list: (obj option) list;
  mutable mons_row_counter: int;
  mutable mons_type_counter: int;
  mutable score : int;
  mutable phase : phase;
  mutable level : int;
  mutable comet_interval : int;
  mutable item_count : int;
  mutable item_msg : string
}

(*[update_state] updates the state of the game*)
val update_state: state -> player -> unit

(*[make_state] initializes state at the start of the Active phase*)
val make_state: int -> int -> state

(*[draw_state] draws representation of the state on to the canvas*)
val draw_state: Dom_html.canvasRenderingContext2D Js.t -> state -> unit

val update_objs_loop: state -> unit list
