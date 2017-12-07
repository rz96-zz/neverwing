open Board
open Gui
open Command
open Collision

type board = Board.board
type phase =
  |Start
  |Active
  |End
type state = {
  mutable board : (obj option) list list;
  mutable control : control;
  mutable player: obj option;
  mutable projectile_list: (obj option) list;
  mutable mons_list: (obj option) list; (*keeps a list of the monsters*)
  mutable mons_row_counter: int;
  mutable mons_type_counter: int;
  mutable score : int;
  mutable phase : phase;
  mutable comet_interval : int;
  mutable item_count : int;
  mutable item_msg : string
}

(*[extract player state] returns the player field from state so
  the fields of player can be changed.*)
let extract_player state=
  match state.player with
    | Some (Player p) -> p
    | _ -> failwith "not a player"

(*[find_coord] and [find_row] are helper functions to traverse through the 2D
  list board and insert objects in the appropriate coordinate of the board*)
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


(*[place_obj board i j obj] places the [obj] on the board at the coordinates
  (i, j)*)
let place_obj board i j obj = find_row board i j obj []

(*[place_objects_list board objs] places all objects in list [objs] onto the
  board [board]*)
let rec place_objects_list board objs =
  match objs with
  | [] -> board
  | obj::t ->
    match obj with
    | Some (Projectile p) -> place_objects_list (place_obj board (p.i) (p.j) obj) t
    | Some (Monster m) -> place_objects_list (place_obj board (m.i) (m.j) obj) t
    | _ -> place_objects_list board t (*if monster was turned to None*)

(*[lower_mons_obj obj] lowers [obj] on the screen by one row, if [obj]
  is a monster*)
let lower_mons_obj mons_obj =
  match mons_obj with
  | Some (Monster m) -> if m.hp <= 0 then None else Some (Monster (lower_mons m))
  | _ -> None (*will never be this case*)

(*[lower_monster_list lst] lowers all the monsters in [lst] on the board*)
let lower_monster_list mons_obj_list =
  List.map lower_mons_obj mons_obj_list

(*[raise_projectile_obj obj] raises [obj] on the screen by one y coordinate, if
  [obj] is a projectile*)
let raise_projectile_obj proj_obj =
  match proj_obj with
  | Some (Projectile p)-> Some (Projectile (raise_proj p))
  | _ -> None

(*[raise_projectile] raises the projectiles in [projectile_list] up one y
  coordinate in the board*)
let raise_projectile projectile_list =
  List.map raise_projectile_obj projectile_list

(*[coord_of_obj_list lst] returns a list of the coordinates (i, j) of the
  objects in list [lst]*)
let rec coord_of_obj_list obj_list init=
  match obj_list with
  | [] -> init
  | (Some (Monster m))::t -> coord_of_obj_list t ((m.i, m.j)::init)
  | (Some (Projectile p))::t -> coord_of_obj_list t ((p.i, p.j)::init)
  | _::t -> coord_of_obj_list t init

(*[replace_with_none lst board] places None on every coordinate in [lst] on
  a [board]*)
let rec replace_with_none coord_list board =
  match coord_list with
  | [] -> board
  | (i, j)::t -> replace_with_none t (place_obj board i j None)


(*[new_location_j] returns the new x coordinate [j] the player will move to
  on the user's input [control]*)
let new_location_j state j control =
  match control with
    | Right -> if j + 1 > 27 then j else j + 1
    | Left -> if j - 1 < 0 then j else j - 1
    | Stop -> j


(*[update_state] is called continuously in the main loop.
  This updates the board, such as updating player position by calling other
  helper functions, updating counters which will determine certain
  events in the game such as health recovery and incoming comets, and updating
  monster and projectile locations.*)
let update_state state (player: player) =
  let i = player.i and j = player.j in
  let j' = new_location_j state j state.control in
  state.item_count <- state.item_count + 1;
  state.comet_interval <- (state.comet_interval + 1) mod (90 / (state.level)) ;

  (******************************PROJECTILES***********************************)
  let new_projectile_list =
    (Some (Projectile {i=i;j=j'+1;collided = false}))::(raise_projectile state.projectile_list) in
  state.board <- replace_with_none (coord_of_obj_list state.projectile_list []) state.board;
  (*updates board with new projectiles*)
  let replaced_projectiles = (raise_projectile new_projectile_list) in

  let filtered_projectiles = List.filter (fun x -> match x with | Some _ -> true | _ -> false)
                              replaced_projectiles in

  state.board <- (place_objects_list state.board filtered_projectiles);
  (*update the projectile list: the new coordinate list of where projectiles are*)
  state.projectile_list <- filtered_projectiles;
  (****************************************************************************)

  (*******************************MONSTERS*************************************)
  let lowered_monsters = lower_monster_list state.mons_list in
  let lowmons_filtered =
    List.filter (fun x -> match x with | Some _ -> true | _ -> false)
                lowered_monsters in
  let new_mons_list =
    if state.mons_row_counter = 0 then
      (if state.score > 70 then lowmons_filtered@(new_row_monsters3 state.mons_type_counter)
       else if state.score > 25 then lowmons_filtered@(new_row_monsters2 state.mons_type_counter)
       else lowmons_filtered@(new_row_monsters1 state.mons_type_counter))
    else lowmons_filtered in (*an obj option list)*)

  let new_mons_list = if (state.comet_interval = 30)
    then (Some (Monster {i=0;j=(extract_player state).j;hp=999;level=4}))::new_mons_list
    else new_mons_list in

  if (state.mons_row_counter = 0) then
    state.mons_type_counter <- (state.mons_type_counter + 1) mod 13;

  (*update board: the row that used to have monsters is replaced with None*)
  state.board <- replace_with_none (coord_of_obj_list state.mons_list []) state.board;
  (*update board: the new row with monsters now is updated to reflect the monsters*)
  state.board <- (place_objects_list state.board new_mons_list);
  (*update mons_coord_list: the new coordinate list of where the monsters are*)

  state.mons_list <- new_mons_list;
  state.mons_row_counter <- (state.mons_row_counter + 1) mod 20;
  (****************************************************************************)

  state.score <- state.score +
                 (List.length lowered_monsters) - (List.length lowmons_filtered);

  (********************************ITEMS**************************************)
  (*Examines counters and health to determine if player has earned a health
    recovery*)
  if ((state.item_count mod 201)  = 200 && (extract_player state).hp < 8) then (extract_player state).hp <- (extract_player state).hp+1;
  if ((state.item_count mod 201)  = 200 && (extract_player state).hp < 8) then state.item_msg <- "Undamaged streak: HP +1";
  if ((state.item_count mod 201)  = 70) then state.item_msg <- "";
  (****************************************************************************)


  (********************************PLAYER**************************************)
  (*these updates the player's location*)
  state.board <- place_obj state.board i j' (Some (Player player));
  player.j <- j';

  if (j = j') then state.control <- (Stop);
  if (state.control != Stop) then
    state.board <- (place_obj state.board i j None)
  else state.board <- (place_obj state.board i j (Some (Player player)))
  (****************************************************************************)

(**END UPDATE_STATE LOOP*******************************************************)


(*[init_row] and [init_board] create the board at the start of the Active phase*)
let rec init_row len arr =
  if (len = 0) then arr else init_row (len-1) (None::arr)

let rec init_board rows cols arr =
  if rows = 0 then arr else init_board (rows-1) cols ((init_row cols [])::arr)

(*[make_state] initializes state at the start of the Active phase*)
let make_state rows cols =
  let board = init_board rows cols ([]) in
  let i = rows-3 and j = cols/2 in
  let main_player = Some (Player {i=i;j=j;hp=10}) in
  let monsters = new_row_monsters1 1 in
  let monsboard = place_objects_list board monsters in
  let playerboard = place_obj monsboard i j main_player in
  let final_board = place_objects_list playerboard new_projectiles in

  let state = {
    board = final_board;
    control = Stop;
    player = main_player;
    projectile_list = new_projectiles;
    mons_list = monsters;
    mons_row_counter = 1;
    mons_type_counter = 1;
    score = 0;
    phase = Start;
    comet_interval = 0;
    item_count = 0;
    item_msg = ""
  } in
  state

(*[draw_state] draws representation of the state on to the canvas*)
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


(*[iter_mons_list state monster_list projectile affected_list] takes
  [monster_list] and iterates through the list to check if any of the
  monsters have collided with [projectile]. If there is a collision, then
  the [collided] field of [projectile] is changed to true, and the collided monster
  [h] is appended to [affected_list]. If a collision does not exist, then
  [iter_mons_list] is called to continue iterating through [monster_list].*)
let rec iter_mons_list state monster_list projectile affected_list =
  match monster_list with
  | [] -> []
  | h::t -> if check_collision h projectile
    then
      ((match projectile with
        | Some (Projectile(p)) -> p.collided <- true
        | _ -> ());
      (h :: iter_mons_list state t None affected_list))
    else iter_mons_list state t projectile affected_list

(*[iter_project_list state projectile_list mons_list affected_list] takes
  [projectile_list] and iterates through the projectiles, calling [iter_mons_list]
    to check if collisions occur between each projectile and [mons_list].*)
let rec iter_project_list state projectile_list mons_list affected_list : (obj option list) list =
  match projectile_list with
  | [] -> []
  | h::t -> iter_mons_list state mons_list h affected_list ::
           iter_project_list state t mons_list affected_list

(*[iter_collision player mon_list] takes [mon_list] and iterates through, checking
  if it has collided with [player]. If a collision exists, then true is returned,
  else [iter_collision] is called and the iteration continues.*)
let rec iter_collision player mon_list =
  match mon_list with
  | [] -> false
  | h::t -> if check_collision player h then true else iter_collision player t

(*[update_monster] reduces the hp of [monster] appropriately
after being attacked by projectiles.*)
let update_monsters monster =
  match monster with
  | Some (Monster m) -> (m.hp <- m.hp - 2)
  | _ -> failwith "not a monster"

(*[update_obj state player mon_list projectile_list] runs the collision checks with
  [iter_collision] and [iter_project_list], and updates the state and health points of
  [player] and [mon_list] accordingly *)
let update_obj state player mon_list projectile_list=
  if iter_collision player mon_list then
    (extract_player state).hp <- (extract_player state).hp-1;
  if iter_collision player mon_list then
    state.item_count <- 0;
  List.map update_monsters (List.concat (iter_project_list state projectile_list mon_list []))

let update_objs_loop state =
  let mon_list = state.mons_list and player = state.player
      and projectile_list = state.projectile_list in
  update_obj state player mon_list projectile_list
