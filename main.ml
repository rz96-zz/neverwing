open Sprite
open Character
module Html = Dom_html


let load _ =
  let canvas =
    Js.Opt.get
      (Js.Opt.bind ( Html.document##getElementByI(Js.string "canvas"))
        Html.CoerceTo.canvas) in
  let context = convas##getContet (Html._2d_ )in
  let bgd = Sprite.setup_sprite "bgd.png"  in
  let bgd_
  print_endline "loading";
  ()

let _ = Html.window##onload <- Dom_html.handler (fun _ -> ignore (load()); Js._true)
