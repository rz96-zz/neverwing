open Collision
open Board

(*[canvas_coords] sets the dimensions of the game*)
val canvas_coords: int*int -> float*float

(*[draw_object context x y obj] draws the object [obj] on the board within the
  given context [context] at the coordinates (x, y)*)
val draw_object: Dom_html.canvasRenderingContext2D Js.t
                    -> int -> int -> obj option -> unit
