open Sprite
open Board

(*[check_collision obj1 obj2] takes in two objects [obj1]
  and [obj2] and checks if their bounding boxes overlap.
  If an overlap exists do, then there is a collision and true is
  returned, else false is returned. *)

val check_collision: obj option -> obj option -> bool
