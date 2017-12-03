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
  | Player
  | Monster of monster
  | Projectile of projectile

type board = (obj option) list list

let lower_mons monster =
  {monster with i = monster.i+1}
