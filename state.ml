open Board
open Sprite
open Gui
open Command


type board = Board.board (*state *)

(*type state = {
  bgd: sprite;
  context: Dom_html.canvasRenderingContext2D Js.t;
  mutable score: int;
  mutable game_over: bool;
  }*)

type state = {
  mutable board : (obj option) list list;
  mutable control : control;
  mutable player_location : int * int;
}

(*[update_state] changes the state according to the command that was given
  (* and moving the rows of monsters down by one each iteration *)
let update_state comm st =
(*every command, you should also update the hp of the monsters
  and of the sprite itself*)
  failwith "Unimplemented" *)



let rec find_coord row j obj new_row =
  let last_col = if j = 0 then true else false in
  match row with
  |[] -> List.rev new_row
  |h::t -> let next = if last_col then obj else h in
    find_coord t (j-1) obj (next::new_row)

let rec find_row board i j obj new_board =
  let last_row = if i = 0 then true else false in
  match board with
  |[] -> List.rev new_board
  |h::t-> let next = if last_row then find_coord h j obj [] else h in
    find_row t (i-1) j obj ((next)::new_board)


let place_obj board i j obj = find_row board i j obj []

let new_location state (i, j) control =
  let (i, j) = match control with
    (*have to make this move after hitting edges*)
    | Right -> if j + 1 > 29 then i, j else i, j + 1
    | Left -> if j - 1 < 0 then i, j else i, j - 1
    | Stop -> i, j
  in
  i , j

let move_player state =
  let i, j = state.player_location in
  let i', j' = new_location state (i, j) state.control in
  state.board <- place_obj state.board i' j' (Some Player);
  state.player_location <- (i', j');
  if (state.control != Stop) then
    state.board <- (place_obj state.board i j None)
  else state.board <- (place_obj state.board i j (Some Player))

(*let update_state canvas =
  let ctx = canvas##getContext (Dom_html._2d_) in
  let state = {
      bgd = Sprite.init_bgd ctx;
      context = ctx;
      score = 0;
      game_over = false;
  } in
  Gui.draw_bgd state.bgd 100.*)


  let rec init_row len arr =
    if (len = 0) then arr else init_row (len-1) (None::arr)

  let rec init_board rows cols arr =
    if rows = 0 then arr else init_board (rows-1) cols ((init_row cols [])::arr)

  (*places all objects on the board given list of objects with coordinates of
    where they are. objs : [((i, j), obj)]*)
  let rec place_objects_list board objs =
    match objs with
    | [] -> board
    | ((i, j), a)::t -> place_objects_list (place_obj board i j a) t

(*creates a new row, full of monsters at the top of the board*)
let rec new_row_monsters =
  [((0, 4), Some Monster);
   ((0, 9), Some Monster);
   ((0, 14), Some Monster);
   ((0, 19), Some Monster);
   ((0, 24), Some Monster)]

let rec new_projectiles = 
  [((42, 15), Some Projectile);
  ((40, 15), Some Projectile);
  ((38, 15), Some Projectile);
  ((36, 15), Some Projectile);
  ((34, 15), Some Projectile);
  ((32, 15), Some Projectile);
  ((30, 15), Some Projectile);
  ((28, 15), Some Projectile);
  ((26, 15), Some Projectile);
  ((24, 15), Some Projectile);
  ((22, 15), Some Projectile);
  ((20, 15), Some Projectile);
  ]

(*lowers a given object on the screen by one row, if it is a monster*)
let lower_mons_obj ((i, j), obj) =
  match obj with
  | Some Player -> ((i, j), obj)
  | Some Monster -> ((i+1, j), obj)
  | None -> ((i, j), obj)

(*lowers an entire row of monsters (or nothing)*)
let lower_monster_row row_of_mons =
  List.map lower_mons_obj row_of_mons

let make_state rows cols =
  let board = init_board rows cols ([]) in
  let i, j = rows-5, cols / 2 in
  let objs = ((i, j), Some Player)::(new_row_monsters) in
  let new_board = place_objects_list board objs in
  let final_board = place_objects_list new_board new_projectiles in
  let state = {
    board = final_board;
    control = Stop;
    player_location = (i, j);
  } in
  state


let draw_state context state =
  let rows = List.length state.board in
  let cols = List.length (List.nth state.board 0) in
  let x, y = canvas_coords (rows, cols) in
  context##clearRect 0. 0. x y;
  for i = 0 to rows - 1 do
    for j = 0 to cols - 1 do
      draw_object context i j (List.nth (List.nth state.board i) j)
    done
  done;
  context##fill
