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

(*who put this in here, and why do we need it here?
  i've used it in the state.ml now though, so if delete, also
  have to fix that ~morena*)
let lower_mons (mons : monster): monster=
  {mons with i = mons.i+1}
