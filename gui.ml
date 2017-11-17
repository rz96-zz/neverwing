(*

let () = Js.Unsafe.global##loadXMLDoc <- Js.wrap_callback loadXMLDoc
let _ = Html.window##onload <- Html.handler (fun _ -> ignore (preload()); Js._true)

just trying something... ?

*)
