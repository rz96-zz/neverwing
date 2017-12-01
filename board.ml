type obj =
  | Player
  | Monster
  | Projectile

type board = (obj option) list list
