type player =
  {
    i: int;
    mutable j: int;
    hp: int;
  }

type monster =
  {
    i : int;
    j : int;
    hp: int
  }

type projectile = 
  {
    i  : int;
    j  : int;
  }

type obj =
  | Player of player
  | Monster of monster
  | Projectile of projectile

(*Type board represents the 2-D grid layout of in the GUI where
  characters would be located*)
  type board = (obj option) list list

val lower_mons : monster -> monster
