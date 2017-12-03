type monster =
  {
    i : int;
    j : int;
    hp: int;
  }


type player =
  {
    i: int;
    mutable j: int;
    hp: int;
  }

type obj =
  | Player of player
  | Monster of monster
  | Projectile

type board = (obj option) list list

let lower_mons monster =
  {monster with i = monster.i+1}
