(*characters are moveable items*)

type direction = | Right | Left

(*Gives xy coordinates of position*)
type xy = {
  mutable x: float;
  mutable y: float;
}

(*Command corresponds to player keyboard input*)
type command = 
  | CLeft
  | CRight
  | CPause
  | None

(*Types of monsters*)
type monster =
  | Boss
  | Medium
  | Small

type damage =
  | Boss_Projectile
  | Monster

type sprite

type projectile

type obj =
  |Damage
  |Sprite
