type monster =
  {
    i : int;
    j : int;
    mutable hp: int;
    level: int;
  }


type player =
  {
    i: int;
    mutable j: int;
    mutable hp: int;
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

type board = (obj option) list list

let lower_mons (mons : monster): monster=
  {mons with i = mons.i+1}

let raise_proj (proj : projectile): projectile = 
  {proj with i = proj.i-1}