open Lwt.Infix
open Board


let flip f x y = f y x

let () = Random.self_init ()

type control =
  | Right
  | Left
  | Stop

(*type obj =
  | Player*)

type action =
  | Nothing

(*type board = (obj option) list list*)

type state = {
  mutable board : (obj option) list list;
  mutable control : control;
  mutable player_location : int * int;
}


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

let update state =
  move_player state

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


let rec new_row_monsters =
  [((5, 4), Some Monster);
   ((5, 9), Some Monster);
   ((5, 14), Some Monster);
   ((5, 19), Some Monster);
   ((5, 24), Some Monster)]


let make_state ~rows ~cols =
  let board = init_board rows cols ([]) in
  let i, j = rows-5, cols / 2 in
<<<<<<< HEAD
  let objs = ((i, j), Some Player)::(new_row_monsters) in
=======
<<<<<<< HEAD
=======

  let objs = [((i, j), Some Player); ((i-10, j-10), Some Monster)] in
>>>>>>> 6ebd9a8331662eceaa37dd4c5b071eb74e93d97f

>>>>>>> 65ab254962fd072448c504a1ef71d455beaea0a1
  let state = {
    board = place_objects_list board objs;
    control = Stop;
    player_location = (i, j);
  } in
  state

let set_control control state =

  state.control <- control



let canvas_coords (i, j) =
  float (j * 10), float (i * 10)

let draw_player context x y =
  context##.fillStyle := Js.string "#0000FF";
  context##fillRect x y 10. 20.

let draw_monster context x y =
  context##.fillStyle := Js.string "#FF0000";
  context##fillRect x y 20. 30.

let draw_object context i j obj =
  let x, y = canvas_coords (i, j) in
  match obj with
  | (Some Player) -> draw_player context x y
  | (Some Monster) -> draw_monster context x y
  | None -> ()

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

let rec main_loop context state =
  (*I don't know what this Lwt thing is*)
  Lwt_js.sleep 0.05 >>= fun () ->
  update state;
  draw_state context state;
  main_loop context state

let key_up state = function
  | "d" -> set_control Stop state
  | "a" -> set_control Stop state
  | _ -> ()

let key_down state = function
  | "d" -> set_control Right state
  | "a" -> set_control Left state
  | _ -> set_control Stop state

let detect_keyup state =
  Lwt_js_events.keyups

    Dom_html.window
    (fun ev _thread ->
       let key_pressed =
         Js.Optdef.get ev##.key
           (fun () -> assert false) in
       key_up state (Js.to_string key_pressed);
       Lwt.return ())

let detect_keydown state =
  Lwt_js_events.keydowns

    Dom_html.window
    (fun ev _thread ->
       let key_pressed =
         Js.Optdef.get ev##.key
           (fun () -> assert false) in
       key_down state (Js.to_string key_pressed);
       Lwt.return ())



let _ : unit Lwt.t =
  let%lwt () = Lwt_js_events.domContentLoaded () in
  let canvas = Dom_html.getElementById "canvas" |> Dom_html.CoerceTo.canvas |> flip Js.Opt.get (fun () -> assert false) in
  let context = canvas##getContext Dom_html._2d_ in
  let state = make_state ~rows:50 ~cols:30 in
  Lwt.join [
    main_loop context state;
    detect_keydown state;
    detect_keyup state;
  ]
