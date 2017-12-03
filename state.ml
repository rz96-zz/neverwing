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
type phase =
  |Start
  |Active
  |End

type state = {
  mutable board : (obj option) list list;
  mutable control : control;
  mutable player_location : int * int;
  mutable projectile_list: ((int * int) * obj option) list;
  mutable mons_list: (obj option) list; (*keeps a list of the monsters*)
  mutable score : int;
  mutable phase : phase
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

(*the obj param is an option type*)
let place_obj board i j obj = find_row board i j obj []

(*places all objects on the board given list of objects with coordinates of
  where they are. mons is the list of monsters*)
let rec place_monsters_list board mons_list =
  match mons_list with
  | [] -> board
  | mons::t ->
    match mons with
    | Some (Monster m) -> place_monsters_list (place_obj board (m.i) (m.j) mons) t
    | _ -> board

(*places all objects on the board given list of objects with coordinates of
  where they are. *)
let rec place_objects_list board objs =
  match objs with
  | [] -> board
  | ((i, j), a)::t -> place_objects_list (place_obj board i j a) t

(*lowers a given object on the screen by one row, if it is a monster*)
let lower_mons_obj mons_obj =
  match mons_obj with
  | Some (Monster m) -> Some (Monster {i=m.i+1; j=m.j; hp=m.hp})
  | _ -> None (*will never be this case*)

(*lowers all the monsters (that are listed in mons_info_list) *)
let lower_monster_row mons_obj_list =
  List.map lower_mons_obj mons_obj_list

(*raise all projectiles listed in projectiles_list*)
let raise_projectile_obj ((i, j), obj) =
  match obj with
  | Some Projectile -> ((i-1, j), obj)
  | _ -> ((i, j), obj)

(*raise the projectiles *)
let raise_projectile projectile_list =
  List.map raise_projectile_obj projectile_list

(* let move_projectile_obj new_j ((i, j), obj) =
  match obj with
  | Some Projectile -> ((i, new_j), obj)
  | _ -> ((i, j), obj)

let rec move_projectile new_j project_list =
  match project_list with
  | [] ->  *)

(*replaces ((i, j) obj) with the object as none if object was monster*)
(*returns a list of where the monsters were*)
let rec coord_of_monster_list mons_obj_list init=
  match mons_obj_list with
  | [] -> init
  | (Some (Monster m))::t -> coord_of_monster_list t ((m.i, m.j)::init)
  | _::t -> coord_of_monster_list t init

(*puts None on every coordinate in coord_list
returns a new board*)
let rec replace_mons_with_none coord_list board =
  match coord_list with
  | [] -> board
  | (i, j)::t -> replace_mons_with_none t (place_obj board i j None)

(*
(*replaces all the coordinates with monsters here with None*)
let replace_all_mons_with_none mons_list =
List.map replace_mons_with_none (coord_of_monster_list mons_list [])*)

(*replaces ((i, j) obj) with the object as none if object was monster*)
let replace_proj_with_none ((i, j), obj) =
  match obj with
  | Some Projectile -> ((i, j),None)
  | _ -> ((i, j), obj)

(*replaces all the coordinates with monsters here with None*)
let replace_all_proj_with_none projectile_list =
  List.map replace_proj_with_none projectile_list


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
  let new_projectile_list = raise_projectile state.projectile_list in

  (*the next three lines of code updates the monster*)
  
  state.board <- (place_objects_list state.board (replace_all_proj_with_none state.projectile_list));
  (*updates board with new projectiles*)
  state.board <- (place_objects_list state.board new_projectile_list);
  (*update the projectile list: the new coordinate list of where projectiles are*)
  state.projectile_list <- new_projectile_list;
  let new_mons_list = lower_monster_row state.mons_list in (*an obj option list)*)

  (*the next three lines of code updates the monster*)
  (*update board: the row that used to have monsters is replaced with None*)
  state.board <- replace_mons_with_none (coord_of_monster_list state.mons_list []) state.board;
  (*update board: the new row with monsters now is updated to reflect the monsters*)
  state.board <- (place_monsters_list state.board new_mons_list);
  (*update mons_coord_list: the new coordinate list of where the monsters are*)
  state.mons_list <- new_mons_list;

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

(*creates a new row, full of monsters at the top of the board
initial state of the mons_list field for state*)
let rec new_row_monsters =
  [
    Some (Monster {i=0;j=4;hp=10});
    Some (Monster {i=0;j=9;hp=10});
    Some (Monster {i=0;j=14;hp=10});
    Some (Monster {i=0;j=19;hp=10});
    Some (Monster {i=0;j=24;hp=10});
  ]
(*  [((0, 4), 10, Some Monster);
   ((0, 9), 10, Some Monster);
   ((0, 14), 10, Some Monster);
   ((0, 19), 10, Some Monster);
   ((0, 24), 10, Some Monster)]
*)
let rec new_projectiles =
  [((42, 15), Some Projectile);
  ]

(*run_collision should pattern match for each possibile collision that could happen
  and execute what happens during the collision eg. new items being made or disappearing*)

(*update_collision should constantly check through update loop if there is a collision occuring*)

(*update_obj updates objects when something collides*)


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
    projectile_list = new_projectiles;
    mons_list = monsters;
    score = 0;
    phase = Start
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

    (*true if collision??*)
let rec iter_collision player mon_list =
  match mon_list with
  |[] -> false
  |h::t -> if check_collision player h then true else iter_collision player t

(*this updates the object and runs the collision check*)
let update_obj state player mon_list=
  if iter_collision player mon_list then
    (*replace update score w/ actual collision processing later*)
    state.score <- state.score + 1



let update_objs_loop state =
  let mon_list = state.mons_list and player = state.player in
  (*need to make player a record*)
  update_obj state mon_list player

(*object list -- iterate through monster list, projectile list, player.
  change this later when have projectile list, currently only iterating
  through player and monster list*)
