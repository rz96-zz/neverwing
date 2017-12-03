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

type board = (obj option) list list

(*who put this in here, and why do we need it here?
  i've used it in the state.ml now though, so if delete, also
  have to fix that ~morena*)
let lower_mons monster =
  {monster with i = monster.i+1}
