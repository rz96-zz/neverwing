open Lwt.Infix
open Board
open Collision
open State
open Command

(*Initialize*)
let () = Random.self_init ()

(*[set_control control state] changes [state]'s control field to [control]*)
let set_control control state =
  state.control <- control

(*[set_phase phase state] changes [state]'s' control field to [phase]*)
let set_phase phase state =
  state.phase <- phase

(*[start_game state pressed] starts game by changing [state] to Active when
  [pressed]*)
let start_game state = function
  | _ -> set_phase Active state

(*[extract_player state] extracts [player] from [state] to allow us to
  change fields in [player]*)
let extract_player state=
  match state.player with
    | Some (Player p) -> p
    | _ -> failwith "not a player" (*will never be this case*)

(*[main_loop] is the main game loop when state is Active and game is ongoing*)
let rec main_loop context state =
  Lwt_js.sleep 0.05 >>= fun () ->
  update_state state (extract_player state);
  draw_state context state;
  update_objs_loop state;
  let key_elt = Dom_html.getElementById "score" in
  key_elt##.innerHTML := (Js.string ("Score: " ^ string_of_int state.score));
  let key_elt = Dom_html.getElementById "powerups" in
  key_elt##.innerHTML := (Js.string ("Power Ups: " ^ state.item_msg));
  let key_elt = Dom_html.getElementById "temp" in
  key_elt##.innerHTML :=
    (Js.string ("HP: " ^ string_of_int (extract_player state).hp));
  if ((extract_player state).hp = 0) then state.phase <- End;
  if (state.phase <> Active) then
  start_loop context state
  else main_loop context state

(*[start_loop] is the game loop before game begins. Detects key presses
  to change to active state in order to go to main game loop.*)
and start_loop context state =
  Lwt_js.sleep 0.05 >>= fun () ->
  let key_elt = Dom_html.getElementById "score" in
  if (state.phase = Start) then
    key_elt##.innerHTML := (Js.string ("Press any key to begin the game"))
  else if (state.phase = End) then
    key_elt##.innerHTML :=
      (Js.string ("Game over. Your score is "^ string_of_int state.score));
    state = make_state 50 30;
  if (state.phase = Active) then main_loop context state
  else start_loop context state

(*[key_up], [key_down], [detect_keyup] [detect_keydown] are helper functions
  that respond to key presses to change the [control] field in [state]
  based on user input*)
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
       if (state.phase = Active)
       then key_down state (Js.to_string key_pressed)
       else if (state.phase = Start)
       then start_game state (Js.to_string key_pressed);
       Lwt.return ())

(*[flip f x y] reverses the inputs [x] and [y] into function [f]*)
let flip f x y = f y x

(*Coerce to canvas*)
let _ : unit Lwt.t =
  let%lwt () = Lwt_js_events.domContentLoaded () in
  let canvas = Dom_html.getElementById "canvas" |> Dom_html.CoerceTo.canvas
               |> flip Js.Opt.get (fun () -> assert false) in
  let context = canvas##getContext Dom_html._2d_ in
  let state = make_state 50 30 in

  Lwt.join [
    start_loop context state;
    detect_keydown state;
    detect_keyup state;
  ]
