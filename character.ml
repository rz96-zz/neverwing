open Sprite
open Command
open Board

(*Type direction corresponds to the direction the character moves in,
either Right or Left*)
(*type direction = | Right | Left

(*Gives xy coordinates of a position on the board*)
type xy = float * float

(*Command corresponds to player keyboard input*)
type command =
  | CLeft
  | CRight
  | CPause
  | None*)

(*Type monsters represents the different types of monsters
there are in the game*)
(*type monster =
  | Boss
  | Medium
  | Small*)

(*Type damage represents the objects that could inflict damage
on a player*)
(*type damage =
  | Boss_Projectile
  | Monster *)

(*Type object is any object that appears on the board*)
(*type obj = {
  sprite: sprite;
  pos: xy;
  }

let new_obj spr_props context position =
  let spr = make_sprite spr_props context in
  {
    sprite = spr;
    pos = position;
  }*)

(*function to get bounding box of a character*)
(*check_collision checks if there is a collision*)
(*run collisions by updating all the collidables & running in update loop
  run on player, also iterate through the list of objects & see if in same
  bounding box as other objects*)

(*let get_row_coord (obj: obj option) =
  match obj with
  | (Some(Monster m)) -> m.i
  | (Some(Player p)) -> p.i
  | (Some (Projectile pro)) -> pro.i

let get_col_coord obj =
  match obj with
  | (Some(Monster m)) -> m.j
  | (Some(Player p)) -> p.j
  | (Some(Projectile pro)) -> pro.j*)

let get_obj_bounds obj =
  match obj with
  | (Some(Monster m)) -> if (m.level = 4) then
      (m.i, m.j, m.i - 8, m.j + 8) else (m.i, m.j, m.i - 2, m.j + 2)
  | (Some(Player p)) -> (p.i, p.j, p.i - 1, p.j)
  | (Some(Projectile pro)) -> (pro.i, pro.j, pro.i, pro.j)
  | None -> (0, 0, 0, 0)

  (*true if collisions*)
let check_collision obj1 obj2 =
  let bounds1 = get_obj_bounds obj1 and bounds2 = get_obj_bounds obj2 in
  match (bounds1, bounds2) with
  | ((bottom_row1, left_col1, top_row1, right_col1), (bottom_row2, left_col2, top_row2, right_col2))
    -> if  (top_row1 = bottom_row2) &&
         (left_col1 <= right_col2) && (right_col1 >= left_col2)
    then true else false

          (*
  let row_coord_1 = get_row_coord obj1 and row_coord_2 = get_row_coord obj2
  and col_coord_1 = get_col_coord obj1 and col_coord_2 = get_col_coord obj2 in
  if ((row_coord_1 = row_coord_2) && (col_coord_1 = col_coord_2)) then
            true else false


*)


    (*get coordinates of obj1 and obj2
    check if there is overlap*)
