(*essentially drawing everything on the playable gui part*)
open Collision
open Sprite
open Board
module Html = Dom_html
let document = Html.document
let jstr = Js.string
let get_context canvas = canvas##getContext (Dom_html._2d_)

let draw sprite (x, y) =
  failwith "Unimplemented"
  (*let context = sprite.context in
  let (sx, sy) = sprite.prop.frame_offset in
  let (sw, sh) = sprite.prop.frame_size in
  let (dx, dy) = (x, y) in
  let (dw, dh) = sprite.prop.frame_size in
  (* let sx = sx +. (float_of_int !(sprite.frame)) *. sw in *)
    context##drawImage_full(sprite.img, sx, sy, sw, sh, dx, dy, dw, dh)*)

let draw_bgd bgd off_x =
  draw bgd ((fst bgd.prop.frame_size) -. off_x, 0.)

let canvas_coords (i, j) =
  float (j * 10), float (i * 10)

let draw_player context x y =
  context##.fillStyle := Js.string "#144e83";
  context##fillRect x y 30. 20.

  (* let make_image img_src =
    let img = (Html.createImg Dom_html.document) in
    img##src := Js.string img_src

  let draw_player context x y =
    let img_src = "./sprites/" ^ ".png" in
    let img = make_image img_src in
    context##drawImage_full(img, x, y, 10., 20., 0, 0, 10., 20.) *)

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



(* let draw_score = failwith "unimplemented"

let game_over = failwith "unimplemented"

let fps = failwith "unimplemented" *)

(*

let () = Js.Unsafe.global##loadXMLDoc <- Js.wrap_callback loadXMLDoc
let _ = Html.window##onload <- Html.handler (fun _ -> ignore (preload()); Js._true)

just trying something... ?

*)
