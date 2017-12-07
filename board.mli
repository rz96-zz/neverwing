(*Type player represents the player of the game*)
type player =
  {
    i: int;
    mutable j: int;
    mutable hp: int;
  }

(*Type monster represents a monster that would descend on the board
  and could damage a player's health, but also be destroyed*)
type monster =
  {
    i : int;
    j : int;
    mutable hp: int;
    level: int;
  }

(*Type projectile represents a projectile that is shot from the player
  to damage monsters*)
type projectile =
  {
    i  : int;
    j  : int;
    mutable collided: bool;
  }

(*Type obj represents any entity/object that would appear on the board*)
type obj =
  | Player of player
  | Monster of monster
  | Projectile of projectile

(*Type board represents the 2-D grid layout of in the GUI where
  characters would be located*)
type board = (obj option) list list

(*[lower_mons] lowers a monster entity on the board, towards the player*)
val lower_mons : monster -> monster

(*[new_row_monsters1] creates a new row full of monsters at the easiest
  level of difficulty*)
val new_row_monsters1 : int -> (obj option) list

(*[new_row_monsters1] creates a new row full of monsters at the easiest
  level of difficulty*)
val new_row_monsters2 : int -> (obj option) list

(*[new_row_monsters3] creates a new row full of monsters at the highest
  level of difficulty*)
val new_row_monsters3_init : int -> int -> (obj option) list

(*[raise_proj] raises a projectile entity on the board, away from player*)
val raise_proj : projectile -> projectile

(*[new_projectiles] initializes new projectiles*)
val new_projectiles : (obj option) list
