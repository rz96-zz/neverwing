(*characters are moveable items*)

type direction = Right | Left

type location = {
  mutable horizontal: float;
  mutable vertical: float;
}


type monster =
  |Boss
  |Medium
  |Small

type damage =
  | Projectile
  | Enemy

type sprite

type projectile

type obj =
  |Damage
  |Sprite
