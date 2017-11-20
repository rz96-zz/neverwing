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
