(*characters are moveable items*)

(*Type direction corresponds to the direction the character moves in,
either Right or Left*)
type direction = | Right | Left

(*Gives xy coordinates of a position on the board*)
type xy = {
  x: float;
  y: float;
}

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

(*Type sprite represents a GAME character (player or monster)*)
type sprite

type player

(*Type projectile represents the projectiles that the player
or boss monsters shoot*)
type projectile

(*Type object is any object that appears on the board*)
type obj =
  | Damage
  | Sprite
