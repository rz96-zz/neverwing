
open Notty
module Term = Notty_unix.Term

let rec play t (x, y) =
  let img =
    let dot = I.string A.(bg red ++ fg red) "xxxx" |> I.pad ~l:x ~t:y
    and txt = I.strf ~attr:A.(fg lightblack) "@(%d, %d)" x y in
    I.(txt </> dot) in
  Term.image t img;
  match Term.event t with
  | `Key (`Escape, []) -> ()
  | `Key (`Arrow d, _) ->
    ( play t @@ match d with
        | `Left  -> if x < 0 then (x,y) else (x - 1, y)
        | `Right -> if (x > 78) then (x,y) else (x + 1, y)
        | _ -> (x,y)    )

  | _ -> play t (x,y)

let () = play (Term.create ()) (35, 15)
