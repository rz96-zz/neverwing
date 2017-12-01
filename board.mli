type monster =
  {
    i : int;
    j : int;
    hp: int
  }

type obj =
  | Player
  | Monster of monster
  | Projectile

(*Type board represents the 2-D grid layout of in the GUI where
  characters would be located*)
  type board = (obj option) list list
