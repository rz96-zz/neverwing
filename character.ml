open Sprite

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
