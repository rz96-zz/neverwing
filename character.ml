open Sprite
open Command

(*Type direction corresponds to the direction the character moves in,
either Right or Left*)
type direction = | Right | Left

(*Gives xy coordinates of a position on the board*)
type xy = float * float

(*Command corresponds to player keyboard input*)
type command =
  | CLeft
  | CRight
  | CPause
  | None

(*Type monsters represents the different types of monsters
there are in the game*)
type monster =
  | Boss
  | Medium
  | Small

(*Type damage represents the objects that could inflict damage
on a player*)
type damage =
  | Boss_Projectile
  | Monster

(*Type object is any object that appears on the board*)
type obj = {
  sprite: sprite;
  pos: xy;
}

let new_obj spr_props context position =
  let spr = make_sprite spr_props context in
  {
    sprite = spr;
    pos = position;
  }

(*function to get bounding box of a character*)
(*check_collision checks if there is a collision*)
(*run collisions by updating all the collidables & running in update loop
  run on player, also iterate through the list of objects & see if in same
  bounding box as other objects*)

let get_row_coord obj =
  match obj with
  |Monster m -> m.i
  |_ -> 0

let get_col_coord obj =
  match obj with
  |Monster m -> m.j
  |_ -> 0

  (*true if collisions*)
let check_collision obj1 obj2 =
  let row_coord_1 = get_row_coord obj1 and row_coord_2 = get_row_coord obj2
  and col_coord_1 = get_col_coord obj1 and col_coord_2 = get_col_coord obj2 in
  if ((row_coord_1 = row_coord_2) && (col_coord_1 = col_coord_2)) then
    true else false


    (*get coordinates of obj1 and obj2
    check if there is overlap*)
