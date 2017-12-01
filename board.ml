type monster =
  {
    mutable i : int;
    mutable j : int;
    mutable hp: int
  }

type obj =
  | Player
  | Monster of monster
  | Projectile

type board = (obj option) list list
