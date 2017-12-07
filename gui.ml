open Collision
open Board
module Html = Dom_html

(*[document] is the Html document*)
let document = Html.document
(*[jstr] is the string in Js*)
let jstr = Js.string
(*[get_context canvas] extracts the context of [canvas]*)
let get_context canvas = canvas##getContext (Dom_html._2d_)

let canvas_coords (i, j) =
  float (j * 10), float (i * 10)

(*[draw_player] draws a 2x3 player on the bottom of the board*)
let draw_player context x y =
  context##.fillStyle := Js.string "#144e83";
  context##fillRect x y 30. 20.

(*[draw monster] draws a 3x3 monster on the board, the color of which depends
  on the [level] of the monster*)
let draw_monster context x y level =
  if level = 1 then
  (context##.fillStyle := Js.string "#B75DF2";
   context##fillRect x y 30. 30.)
  else if level = 2 then
  (context##.fillStyle := Js.string "#7224a7";
   context##fillRect x y 30. 30.)
  else if level = 3 then
    (context##.fillStyle := Js.string "#4d0083";
     context##fillRect x y 30. 30.)
  else
    (context##.fillStyle := Js.string "#B31B1B";
     context##fillRect x y 60. 60.)

(*[draw_projectile] draws a 1x1 projectile on the board. If [collided], then
  does not draw a projectile*)
let draw_projectile context x y collided =
  if collided then
  (context##.fillStyle := Js.string "#FFFFFF";
   context##fillRect x y 0. 0.)
  else
    (context##.fillStyle := Js.string "#000000";
    context##fillRect x y 10. 10.;)

let draw_object context i j obj =
  let x, y = canvas_coords (i, j) in
  match obj with
  | (Some (Player p)) -> draw_player context x y
  | (Some (Monster m)) -> draw_monster context x y m.level
  | (Some (Projectile p)) -> draw_projectile context x y p.collided
  | None -> ()
