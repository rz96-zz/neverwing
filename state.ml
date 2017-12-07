open Board
open Sprite
open Gui
open Command
open Character


type board = Board.board

(*Phase of the game*)
type phase =
  |Start
  |Active
  |End

(*State represents the game state which consists of the game board
  user input (control), the player, lists of everything on the board
  ,score, game phase, level of diffiuclty and counters to signifiy
  certain game actions*)
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
  mutable level : int;
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

(*Helper functions to traverse through the 2d list board and insert objects
in the appropriate coordinate of the board*)
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
  where they are. *)
let rec place_objects_list board objs =
  match objs with
  | [] -> board
  | obj::t ->
    match obj with
    | Some (Projectile p) -> place_objects_list (place_obj board (p.i) (p.j) obj) t
    | Some (Monster m) -> place_objects_list (place_obj board (m.i) (m.j) obj) t
    | _ -> place_objects_list board t (*if monster was turned to None*)

(*lowers a given object on the screen by one row, if it is a monster*)
let lower_mons_obj mons_obj =
  match mons_obj with
  | Some (Monster m) -> if m.hp <= 0 then None else Some (Monster (lower_mons m))
  | _ -> None (*will never be this case*)

(*lowers all the monsters (that are listed in mons_info_list) *)
let lower_monster_list mons_obj_list =
  List.map lower_mons_obj mons_obj_list

(*[raise_projectile_obj] is a helper function that individually moves one
peojectile object up one in the board*)
let raise_projectile_obj proj_obj =
  match proj_obj with
  | Some (Projectile p)-> Some (Projectile {i=p.i-1; j=p.j})
  | _ -> None

(*[raise_projectile] raises the projectiles in [projectile_list] up one y
  coordinate in the board*)
let raise_projectile projectile_list =
  List.map raise_projectile_obj projectile_list

(*replaces ((i, j) obj) with the object as none if object was monster*)
(*returns a list of where the monsters or projectileswere*)
let rec coord_of_obj_list obj_list init=
  match obj_list with
  | [] -> init
  | (Some (Monster m))::t -> coord_of_obj_list t ((m.i, m.j)::init)
  | (Some (Projectile p))::t -> coord_of_obj_list t ((p.i, p.j)::init)
  | _::t -> coord_of_obj_list t init

(*puts None on every coordinate in coord_list
returns a new board*)
let rec replace_with_none coord_list board =
  match coord_list with
  | [] -> board
  | (i, j)::t -> replace_with_none t (place_obj board i j None)

(*[new_row_monsters1 count] creates a new row, full of monsters at the top of
  the board. This row varies depending on what value [count] is. These cases
  for [count] give us varied patterns for the monsters. These are all monsters
at the easiest difficulty*)
let rec new_row_monsters1 count =
  match count with
  |1->[
    Some (Monster {i=0;j=4;hp=10;level=1});
    Some (Monster {i=0;j=9;hp=10;level=1});
    Some (Monster {i=0;j=14;hp=10;level=1});
    Some (Monster {i=0;j=19;hp=10;level=1});
    Some (Monster {i=0;j=24;hp=10;level=1});
  ]
  |2-> [
      Some (Monster {i=0;j=4;hp=10;level=1});
      Some (Monster {i=0;j=14;hp=10;level=1});
      Some (Monster {i=0;j=24;hp=10;level=1});
    ]
  |13 ->[
      Some (Monster {i=0;j=4;hp=10;level=1});
      Some (Monster {i=0;j=9;hp=10;level=1});
      Some (Monster {i=0;j=19;hp=10;level=1});
    ]
  |3 ->[
      Some (Monster {i=0;j=4;hp=10;level=1});
      Some (Monster {i=0;j=24;hp=10;level=1});
    ]
  |4 ->[
      Some (Monster {i=0;j=4;hp=10;level=1});
      Some (Monster {i=0;j=9;hp=10;level=1});
      Some (Monster {i=0;j=24;hp=10;level=1});
    ]
  |5 ->[
      Some (Monster {i=0;j=14;hp=10;level=1});
      Some (Monster {i=0;j=19;hp=10;level=1});
    ]
  |6 ->[

      Some (Monster {i=0;j=9;hp=10;level=1});
      Some (Monster {i=0;j=24;hp=10;level=1});
    ]
  |7 ->[
      Some (Monster {i=0;j=4;hp=10;level=1});
      Some (Monster {i=0;j=9;hp=10;level=1});
      Some (Monster {i=0;j=14;hp=10;level=1});
      Some (Monster {i=0;j=19;hp=10;level=1});
    ]
  |8 ->[
      Some (Monster {i=0;j=9;hp=10;level=1});
      Some (Monster {i=0;j=14;hp=10;level=1});
      Some (Monster {i=0;j=19;hp=10;level=1});
    ]
  |9 ->[
      (*Some (Monster {i=0;j=4;hp=10;level=1});*)
      Some (Monster {i=0;j=9;hp=10;level=1});
      (*Some (Monster {i=0;j=14;hp=10;level=1});*)
      Some (Monster {i=0;j=19;hp=10;level=1});
      (*Some (Monster {i=0;j=24;hp=10;level=1});*)
    ]
  |10 ->[
      Some (Monster {i=0;j=4;hp=10;level=1});
      (*Some (Monster {i=0;j=9;hp=10;level=1});*)
      (*Some (Monster {i=0;j=14;hp=10;level=1});*)
      Some (Monster {i=0;j=19;hp=10;level=1});
      (*Some (Monster {i=0;j=24;hp=10;level=1});*)
    ]
  |11 ->[
      (*Some (Monster {i=0;j=4;hp=10;level=1});*)
      Some (Monster {i=0;j=9;hp=10;level=1});
      (*Some (Monster {i=0;j=14;hp=10;level=1});*)
      Some (Monster {i=0;j=19;hp=10;level=1});
      (*Some (Monster {i=0;j=24;hp=10;level=1});*)

    ]
  |12 ->[
      Some (Monster {i=0;j=4;hp=10;level=1});
      Some (Monster {i=0;j=9;hp=10;level=1});
      (*Some (Monster {i=0;j=14;hp=10;level=1});*)
      (*Some (Monster {i=0;j=19;hp=10;level=1});
        Some (Monster {i=0;j=24;hp=10;level=1});*)
    ]
  |_-> [
      (*Some (Monster {i=0;j=4;hp=10;level=1});*)
      (*Some (Monster {i=0;j=9;hp=10;level=1});*)
      Some (Monster {i=0;j=14;hp=10;level=1});
      (*Some (Monster {i=0;j=19;hp=10;level=1});*)
      Some (Monster {i=0;j=24;hp=10;level=1});
    ]
(*[new_row_monsters2 count] creates a new row, full of monsters at the top of
  the board. This row varies depending on what value [count] is. These cases
  for [count] give us varied patterns for the monsters. These are all monsters
  at the middle difficulty*)
let rec new_row_monsters2 count =
  match count with
  |1->[
      Some (Monster {i=0;j=4;hp=20;level=2});
      Some (Monster {i=0;j=9;hp=20;level=2});
      Some (Monster {i=0;j=14;hp=20;level=2});
      Some (Monster {i=0;j=19;hp=20;level=2});
      Some (Monster {i=0;j=24;hp=20;level=2});
    ]
  |2-> [
      Some (Monster {i=0;j=4;hp=20;level=2});
      (*Some (Monster {i=0;j=9;hp=10;level=1});*)
      Some (Monster {i=0;j=14;hp=20;level=2});
      (*Some (Monster {i=0;j=19;hp=10;level=1});*)
      Some (Monster {i=0;j=24;hp=20;level=2});
    ]
  |3 ->[
      Some (Monster {i=0;j=4;hp=20;level=2});
      Some (Monster {i=0;j=9;hp=20;level=2});
      (*Some (Monster {i=0;j=14;hp=10;level=1});*)
      Some (Monster {i=0;j=19;hp=20;level=2});
      (*Some (Monster {i=0;j=24;hp=10;level=1});*)
    ]
  |13 ->[
      Some (Monster {i=0;j=4;hp=20;level=2});
      (*Some (Monster {i=0;j=9;hp=10;level=1});*)
      (*Some (Monster {i=0;j=14;hp=10;level=1});*)
      (*Some (Monster {i=0;j=19;hp=10;level=1});*)
      Some (Monster {i=0;j=24;hp=20;level=2});
    ]
  |4 ->[
      Some (Monster {i=0;j=4;hp=20;level=2});
      Some (Monster {i=0;j=9;hp=20;level=2});
      (*Some (Monster {i=0;j=14;hp=10;level=1});*)
      (*Some (Monster {i=0;j=19;hp=10;level=1});*)
      Some (Monster {i=0;j=24;hp=20;level=2});
    ]
  |5 ->[
      (*Some (Monster {i=0;j=4;hp=10;level=1});
        Some (Monster {i=0;j=9;hp=10;level=1});*)
      Some (Monster {i=0;j=14;hp=20;level=2});
      Some (Monster {i=0;j=19;hp=20;level=2});
      (*Some (Monster {i=0;j=24;hp=10;level=1});*)
    ]
  |6 ->[
      (*Some (Monster {i=0;j=4;hp=10;level=1});*)
      Some (Monster {i=0;j=9;hp=20;level=2});
      (*Some (Monster {i=0;j=14;hp=10;level=1});
        Some (Monster {i=0;j=19;hp=10;level=1});*)
      Some (Monster {i=0;j=24;hp=20;level=2});
    ]
  |7 ->[
      Some (Monster {i=0;j=4;hp=20;level=2});
      Some (Monster {i=0;j=9;hp=20;level=2});
      Some (Monster {i=0;j=14;hp=20;level=2});
      Some (Monster {i=0;j=19;hp=20;level=2});
      (*Some (Monster {i=0;j=24;hp=10;level=1});*)
    ]
  |8 ->[
      (*Some (Monster {i=0;j=4;hp=10;level=1});*)
      Some (Monster {i=0;j=9;hp=20;level=2});
      Some (Monster {i=0;j=14;hp=20;level=2});
      Some (Monster {i=0;j=19;hp=20;level=2});
      (*Some (Monster {i=0;j=24;hp=10;level=1});*)
    ]
  |9 ->[
      (*Some (Monster {i=0;j=4;hp=10;level=1});*)
      Some (Monster {i=0;j=9;hp=20;level=2});
      (*Some (Monster {i=0;j=14;hp=10;level=1});*)
      Some (Monster {i=0;j=19;hp=20;level=2});
      (*Some (Monster {i=0;j=24;hp=10;level=1});*)
    ]
  |10 ->[
      Some (Monster {i=0;j=4;hp=20;level=2});
      (*Some (Monster {i=0;j=9;hp=10;level=1});*)
      (*Some (Monster {i=0;j=14;hp=10;level=1});*)
      Some (Monster {i=0;j=19;hp=20;level=2});
      (*Some (Monster {i=0;j=24;hp=10;level=1});*)
    ]
  |11 ->[
      (*Some (Monster {i=0;j=4;hp=10;level=1});*)
      Some (Monster {i=0;j=9;hp=20;level=2});
      (*Some (Monster {i=0;j=14;hp=10;level=1});*)
      Some (Monster {i=0;j=19;hp=20;level=2});
      (*Some (Monster {i=0;j=24;hp=10;level=1});*)

    ]
  |12 ->[
      Some (Monster {i=0;j=4;hp=20;level=2});
      Some (Monster {i=0;j=9;hp=20;level=2});
      (*Some (Monster {i=0;j=14;hp=10;level=1});*)
      (*Some (Monster {i=0;j=19;hp=10;level=1});
        Some (Monster {i=0;j=24;hp=10;level=1});*)
    ]
  |_-> [
      (*Some (Monster {i=0;j=4;hp=10;level=1});*)
      (*Some (Monster {i=0;j=9;hp=10;level=1});*)
      Some (Monster {i=0;j=14;hp=20;level=2});
      (*Some (Monster {i=0;j=19;hp=10;level=1});*)
      Some (Monster {i=0;j=24;hp=20;level=2});
    ]

(*[new_row_monsters3 count] creates a new row, full of monsters at the top of
  the board. This row varies depending on what value [count] is. These cases
  for [count] give us varied patterns for the monsters. These are all monsters
  at the hardest difficulty*)
let rec new_row_monsters3 count difficulty state =
  state.level <- (state.level + 1) mod 8;
  match count with
  |1->[
      Some (Monster {i=0;j=4;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=9;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=14;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=19;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=24;hp=20+(difficulty*5);level=3});
    ]
  |2-> [
      Some (Monster {i=0;j=4;hp=20+(difficulty*5);level=3});
      (*Some (Monster {i=0;j=9;hp=10;level=1});*)
      Some (Monster {i=0;j=14;hp=20+(difficulty*5);level=3});
      (*Some (Monster {i=0;j=19;hp=10;level=1});*)
      Some (Monster {i=0;j=24;hp=20+(difficulty*5);level=3});
    ]
  |3 ->[
      Some (Monster {i=0;j=4;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=9;hp=20+(difficulty*5);level=3});
      (*Some (Monster {i=0;j=14;hp=10;level=1});*)
      Some (Monster {i=0;j=19;hp=20+(difficulty*5);level=3});
      (*Some (Monster {i=0;j=24;hp=10;level=1});*)
    ]
  |13 ->[
      Some (Monster {i=0;j=4;hp=20+(difficulty*5);level=3});
      (*Some (Monster {i=0;j=9;hp=10;level=1});*)
      (*Some (Monster {i=0;j=14;hp=10;level=1});*)
      (*Some (Monster {i=0;j=19;hp=10;level=1});*)
      Some (Monster {i=0;j=24;hp=20+(difficulty*5);level=3});
    ]
  |4 ->[
      Some (Monster {i=0;j=4;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=9;hp=20+(difficulty*5);level=3});
      (*Some (Monster {i=0;j=14;hp=10;level=1});*)
      (*Some (Monster {i=0;j=19;hp=10;level=1});*)
      Some (Monster {i=0;j=24;hp=20+(difficulty*5);level=3});
    ]
  |5 ->[
      (*Some (Monster {i=0;j=4;hp=10;level=1});
        Some (Monster {i=0;j=9;hp=10;level=1});*)
      Some (Monster {i=0;j=14;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=19;hp=20+(difficulty*5);level=3});
      (*Some (Monster {i=0;j=24;hp=10;level=1});*)
    ]
  |6 ->[
      (*Some (Monster {i=0;j=4;hp=10;level=1});*)
      Some (Monster {i=0;j=9;hp=20+(difficulty*5);level=3});
      (*Some (Monster {i=0;j=14;hp=10;level=1});
        Some (Monster {i=0;j=19;hp=10;level=1});*)
      Some (Monster {i=0;j=24;hp=20+(difficulty*5);level=3});
    ]
  |7 ->[
      Some (Monster {i=0;j=4;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=9;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=14;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=19;hp=20+(difficulty*5);level=3});
      (*Some (Monster {i=0;j=24;hp=10;level=1});*)
    ]
  |8 ->[
      (*Some (Monster {i=0;j=4;hp=10;level=1});*)
      Some (Monster {i=0;j=9;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=14;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=19;hp=20+(difficulty*5);level=3});
      (*Some (Monster {i=0;j=24;hp=10;level=1});*)
    ]
  |9 ->[
      (*Some (Monster {i=0;j=4;hp=10;level=1});*)
      Some (Monster {i=0;j=9;hp=20+(difficulty*5);level=3});
      (*Some (Monster {i=0;j=14;hp=10;level=1});*)
      Some (Monster {i=0;j=19;hp=20+(difficulty*5);level=3});
      (*Some (Monster {i=0;j=24;hp=10;level=1});*)
    ]
  |10 ->[
      Some (Monster {i=0;j=4;hp=20+(difficulty*5);level=3});
      (*Some (Monster {i=0;j=9;hp=10;level=1});*)
      (*Some (Monster {i=0;j=14;hp=10;level=1});*)
      Some (Monster {i=0;j=19;hp=20+(difficulty*5);level=3});
      (*Some (Monster {i=0;j=24;hp=10;level=1});*)
    ]
  |11 ->[
      (*Some (Monster {i=0;j=4;hp=10;level=1});*)
      Some (Monster {i=0;j=9;hp=20+(difficulty*5);level=3});
      (*Some (Monster {i=0;j=14;hp=10;level=1});*)
      Some (Monster {i=0;j=19;hp=20+(difficulty*5);level=3});
      (*Some (Monster {i=0;j=24;hp=10;level=1});*)

    ]
  |12 ->[
      Some (Monster {i=0;j=4;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=9;hp=20+(difficulty*5);level=3});
      (*Some (Monster {i=0;j=14;hp=10;level=1});*)
      (*Some (Monster {i=0;j=19;hp=10;level=1});
        Some (Monster {i=0;j=24;hp=10;level=1});*)
    ]
  |_-> [
      (*Some (Monster {i=0;j=4;hp=10;level=1});*)
      (*Some (Monster {i=0;j=9;hp=10;level=1});*)
      Some (Monster {i=0;j=14;hp=20+(difficulty*5);level=3});
      (*Some (Monster {i=0;j=19;hp=10;level=1});*)
      Some (Monster {i=0;j=24;hp=20+(difficulty*5);level=3});
    ]

(*[new_location_j] returns the new x coordinate [j] the player will move to
  on the user's input [control]*)
let new_location_j state j control =
  match control with
    | Right -> if j + 1 > 27 then j else j + 1
    | Left -> if j - 1 < 0 then j else j - 1
    | Stop -> j


(*[move_player] is called continuously in the main loop.
  This updates the player position by calling other Helper
  functions, updates counters which will determine certain
  events in the game such as health recovery and incoming comets.
  The board is also updated in [move_player].*)
let move_player state (player: player) =
  let i = player.i and j = player.j in
  let j' = new_location_j state j state.control in
  state.item_count <- state.item_count + 1;

  let new_projectile_list =
    (Some (Projectile {i=i;j=j'+1}))::(raise_projectile state.projectile_list) in

  state.comet_interval <- (state.comet_interval + 1) mod (90 / (state.level)) ;
  state.board <- replace_with_none (coord_of_obj_list state.projectile_list []) state.board;

  (*updates board with new projectiles*)
  let replaced_projectiles = (raise_projectile new_projectile_list) in
  state.board <- (place_objects_list state.board replaced_projectiles);
  (*update the projectile list: the new coordinate list of where projectiles are*)
  state.projectile_list <- replaced_projectiles;


  let lowered_monsters = lower_monster_list state.mons_list in
  let lowmons_filtered =
    List.filter (fun x -> match x with | Some _ -> true | _ -> false)
                lowered_monsters in
  let new_mons_list =
    if state.mons_row_counter = 0 then
      (if state.score > 50 then lowmons_filtered@(new_row_monsters3 state.mons_type_counter state.level state)
       else if state.score > 25 then lowmons_filtered@(new_row_monsters2 state.mons_type_counter)
       else lowmons_filtered@(new_row_monsters1 state.mons_type_counter))
    else lowmons_filtered in (*an obj option list)*)

  let new_mons_list = if (state.comet_interval = 30) then (Some (Monster {i=0;j=(extract_player state).j;hp=999;level=4}))::new_mons_list
    else new_mons_list in

  if (state.mons_row_counter = 0) then
    state.mons_type_counter <- (state.mons_type_counter + 1) mod 13;

  (*Examines counters and health to determine if player has earned a health
  recovery*)
  if ((state.item_count mod 201)  = 200 && (extract_player state).hp < 8) then (extract_player state).hp <- (extract_player state).hp+1;
  if ((state.item_count mod 201)  = 200 && (extract_player state).hp < 8) then state.item_msg <- "Undamaged streak: HP +1";
  if ((state.item_count mod 201)  = 70) then state.item_msg <- "";

  (*update board: the row that used to have monsters is replaced with None*)
  state.board <- replace_with_none (coord_of_obj_list state.mons_list []) state.board;
  (*update board: the new row with monsters now is updated to reflect the monsters*)
  state.board <- (place_objects_list state.board new_mons_list);
  (*update mons_coord_list: the new coordinate list of where the monsters are*)
  state.mons_list <- new_mons_list;
  state.mons_row_counter <- (state.mons_row_counter + 1) mod 20;

  state.score <- state.score +
                 (List.length lowered_monsters) - (List.length lowmons_filtered);

  (*these updates the player's location*)
  state.board <- place_obj state.board i j' (Some (Player player));
  player.j <- j';

  if (j = j') then state.control <- (Stop);
  if (state.control != Stop) then
    state.board <- (place_obj state.board i j None)
  else state.board <- (place_obj state.board i j (Some (Player player)))


(*These functions create the board at the start of the Active phase*)
let rec init_row len arr =
  if (len = 0) then arr else init_row (len-1) (None::arr)

let rec init_board rows cols arr =
  if rows = 0 then arr else init_board (rows-1) cols ((init_row cols [])::arr)

(*Initializes new projectiles*)
let rec new_projectiles =
  [Some (Projectile {i=42;j=16});Some (Projectile {i=44;j=16});Some (Projectile {i=46;j=16})]


(*run_collision should pattern match for each possible collision that could happen
  and execute what happens during the collision eg. new items being made or disappearing*)

(*update_collision should constantly check through update loop if there is a collision occuring*)

(*update_obj updates objects when something collides*)

(*Initializes state at the start of the Active phase*)
let make_state rows cols =
  let board = init_board rows cols ([]) in
  let i = rows-3 and j = cols/2 in
  let main_player = Some (Player {i=i;j=j;hp=10}) in
  let monsters = new_row_monsters1 1 in
  let monsboard = place_objects_list board monsters in (*the board with monsters*)
  let newboard = place_obj monsboard i j main_player in (*board with monsters and player*)
  let final_board = place_objects_list newboard new_projectiles in (*board with monsters, players, and projectiles*)

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
    level = 1;
    comet_interval = 0;
    item_count = 0;
    item_msg = ""
  } in
  state

(*Draws representation of the state on to the canvas*)
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

(*true if collisions exists between projectile list and the monster*)
let rec iter_mons_list state monster_list projectile affected_list =
  match monster_list with
  | [] -> []
  | h::t -> if check_collision h projectile
    then
      (*state.projectile_list <-
          filter_projectile projectile (hide_projectile projectile state.projectile_list)*)
        ((h :: iter_mons_list state t None affected_list))
    else iter_mons_list state t projectile affected_list


(*true if collisions exist between projectile list and monster list*)
let rec iter_project_list state projectile_list mons_list affected_list : (obj option list) list =
  match projectile_list with
  | [] -> []
  | h::t -> iter_mons_list state mons_list h affected_list ::
           iter_project_list state t mons_list affected_list

(*true if collision between player and monster list*)
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



(*this updates the object and runs the collision check*)
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
