(*essentially drawing everything on the playable gui part*)
open Character
open Sprite
module Html = Dom_html
let document = Html.document
let jstr = Js.string
let get_context canvas = canvas##getContext (Dom_html._2d_)

let draw sprite (x, y) = 
  let context = sprite.context in
  let (sx, sy) = sprite.prop.frame_offset in
  let (sw, sh) = sprite.prop.frame_size in
  let (dx, dy) = (x, y) in
  let (dw, dh) = sprite.prop.frame_size in
  (* let sx = sx +. (float_of_int !(sprite.frame)) *. sw in *)
  context##drawImage_full(sprite.img, sx, sy, sw, sh, dx, dy, dw, dh)

let draw_bgd bgd off_x =
  draw bgd ((fst bgd.prop.frame_size) -. off_x, 0.)
(* let draw_score = failwith "unimplemented"

let game_over = failwith "unimplemented"

let fps = failwith "unimplemented" *)

(*

let () = Js.Unsafe.global##loadXMLDoc <- Js.wrap_callback loadXMLDoc
let _ = Html.window##onload <- Html.handler (fun _ -> ignore (preload()); Js._true)

just trying something... ?

*)
