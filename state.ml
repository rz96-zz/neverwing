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
  mutable mons_info_list: ((int * int) * int * obj option) list;
  mutable score : int
(*keeps a list of the coordinates of the monsters*)
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

(*places all objects on the board given list of objects with coordinates of
  where they are. mons : [((i, j), hp, obj)]*)
let rec place_monsters_list board mons =
  match mons with
  | [] -> board
  | ((i, j), hp, a)::t -> place_monsters_list (place_obj board i j a) t

(*lowers a given object on the screen by one row, if it is a monster*)
let lower_mons_obj ((i, j), hp, obj) =
  match obj with
  | Some Monster -> ((i+1, j), hp, obj)
  | _ -> ((i, j), hp, obj) (*will never be this case*)

(*lowers all the monsters (that are listed in mons_info_list) *)
let lower_monster_row mons_info_list =
  List.map lower_mons_obj mons_info_list

(*replaces ((i, j) obj) with the object as none if object was monster*)
let replace_mons_with_none ((i, j), hp, obj) =
  match obj with
  | Some Monster -> ((i, j), hp, None)
  | _ -> ((i, j), hp, obj)

(*replaces all the coordinates with monsters here with None*)
let replace_all_mons_with_none mons_info_list =
  List.map replace_mons_with_none mons_info_list

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
  let new_mons_info_list = lower_monster_row state.mons_info_list in

  (*the next three lines of code updates the monster*)
  (*update board: the row that used to have monsters is replaced with None*)
  state.board <- (place_monsters_list state.board
                    (replace_all_mons_with_none state.mons_info_list));
  (*update board: the new row with monsters now is updated to reflect the monsters*)
  state.board <- (place_monsters_list state.board new_mons_info_list);
  (*update mons_coord_list: the new coordinate list of where the monsters are*)
  state.mons_info_list <- new_mons_info_list;

  (*these updates the player's location*)
  state.board <- place_obj state.board i' j' (Some Player);
  state.player_location <- (i', j');
  if (j = j') then state.control <- (Stop);
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

(*creates a new row, full of monsters at the top of the board*)
let rec new_row_monsters =
  [((0, 4), 10, Some Monster);
   ((0, 9), 10, Some Monster);
   ((0, 14), 10, Some Monster);
   ((0, 19), 10, Some Monster);
   ((0, 24), 10, Some Monster)]

let rec new_projectiles =
  [((42, 15), Some Projectile);
  ]

(*run_collision should pattern match for each possibile collision that could happen
  and execute what happens during the collision eg. new items being made or disappearing*)

(*update_collision should constantly check through update loop if there is a collision occuring*)

(*update_obj updates objects when something collides*)

  let rec place_objects_list board objs =
    match objs with
    | [] -> board
    | ((i, j), a)::t -> place_objects_list (place_obj board i j a) t


let make_state rows cols =
  let board = init_board rows cols ([]) in
  let i, j = rows-5, cols / 2 in
  let monsters = new_row_monsters in
  let monsboard = place_monsters_list board monsters in (*the board with monsters*)
  let newboard = place_obj monsboard i j (Some Player) in (*board with monsters and player*)

  let final_board = place_objects_list newboard new_projectiles in (*board with monsters, players, and projectiles*)

  let state = {
    board = final_board;
    control = Stop;
    player_location = (i, j);
    mons_info_list = monsters;
    score = 0;
    (*coordinates of the monsters*)
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

(*this updates the object and runs the collision check*)
let update_obj =



let update_objs_loop mon_list player =


    (*object list -- iterate through monster list, projectile list, player*)
