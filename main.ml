open Sprite
open Character
open State
module Html = Dom_html


let load _ =
  Random.self_init();
  let canvas =
    Js.Opt.get
      (Js.Opt.bind ( Html.document##getElementById(Js.string "canvas"))
        Html.CoerceTo.canvas)
        (fun () ->
        Printf.printf "cant find canvas id";
        failwith "fail"
      ) in
  let context = canvas##getContext (Html._2d_)in
  let _ = State.update_state canvas in
  print_endline "loading";
  ()

let _ = Html.window##onload <- Html.handler (fun _ -> ignore (load()); Js._true)




      (*state update*)(*
let update_state canvas =
  let ctx = canvas##getContext (Dom_html._2d_) in
  let state = {
    bgd = Sprite.init_bgd ctx;(*1*)
      context = ctx;
      score = 0;
      game_over = false;
    } in
  (*6*)
  Gui.draw_bgd state.bgd 100.

let init_bgd context = (*2*)
  let prop = init_sprite "bgd.png" (500., 600.) (0., 0.) in
  (*4*)
    make_sprite prop context

let init_sprite img_src frame_size frame_offset = (*3*)
  let img_src = "./sprites/" ^ img_src in
  {
    img_src;
    frame_size;
    frame_offset;
  }

let make_sprite prop context = (*5*)
  let img = (Dom_html.createImg Dom_html.document) in
  img##src <- (Js.string prop.img_src);
  {
    prop;
    context;
    img;
  }

let draw sprite (x, y) =
  let context = sprite.context in
  let (sx, sy) = sprite.prop.frame_offset in
  let (sw, sh) = sprite.prop.frame_size in
  let (dx, dy) = (x, y) in
  let (dw, dh) = sprite.prop.frame_size in
  (* let sx = sx +. (float_of_int !(sprite.frame)) *. sw in *)
  context##drawImage_full(Js.string "./sprites/pgd.png", sx, sy, sw, sh, dx, dy, dw, dh)

let draw_bgd bgd off_x =
        draw bgd ((fst bgd.prop.frame_size) -. off_x, 0.)
      *)
