open Sprite
open Character
open State
module Html = Dom_html


let load _ =
  let canvas =
    Js.Opt.get
      (Js.Opt.bind ( Html.document##getElementByI(Js.string "canvas"))
        Html.CoerceTo.canvas) in
  let context = convas##getContext (Html._2d_)in
  let _ = State.update_state canvas sin
  print_endline "loading";
  ()

let _ = Html.window##onload <- Dom_html.handler (fun _ -> ignore (load()); Js._true)
