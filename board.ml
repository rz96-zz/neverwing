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
    mutable collided: bool;
  }

type obj =
  | Player of player
  | Monster of monster
  | Projectile of projectile

type board = (obj option) list list

let lower_mons (mons : monster): monster=
  {mons with i = mons.i+1}

(*[new_row_monsters1 count] creates a new row, full of monsters at the top of
  the board. This row varies depending on what value [count] is. These cases
  for [count] give us varied patterns for the monsters. These are all monsters
  at the easiest difficulty*)
let new_row_monsters1 count =
  match count with
  |1->[
      Some (Monster {i=0;j=4;hp=10;level=1});
      Some (Monster {i=0;j=9;hp=10;level=1});
      Some (Monster {i=0;j=14;hp=10;level=1});
      Some (Monster {i=0;j=19;hp=10;level=1});
      Some (Monster {i=0;j=24;hp=10;level=1});
    ]
  |2-> [
      Some (Monster {i=0;j=4;hp=10;level=1});
      Some (Monster {i=0;j=14;hp=10;level=1});
      Some (Monster {i=0;j=24;hp=10;level=1});
    ]
  |3 ->[
      Some (Monster {i=0;j=4;hp=10;level=1});
      Some (Monster {i=0;j=24;hp=10;level=1});
    ]
  |4 ->[
      Some (Monster {i=0;j=4;hp=10;level=1});
      Some (Monster {i=0;j=9;hp=10;level=1});
      Some (Monster {i=0;j=24;hp=10;level=1});
    ]
  |5 ->[
      Some (Monster {i=0;j=14;hp=10;level=1});
      Some (Monster {i=0;j=19;hp=10;level=1});
    ]
  |6 ->[

      Some (Monster {i=0;j=9;hp=10;level=1});
      Some (Monster {i=0;j=24;hp=10;level=1});
    ]
  |7 ->[
      Some (Monster {i=0;j=4;hp=10;level=1});
      Some (Monster {i=0;j=9;hp=10;level=1});
      Some (Monster {i=0;j=14;hp=10;level=1});
      Some (Monster {i=0;j=19;hp=10;level=1});
    ]
  |8 ->[
      Some (Monster {i=0;j=9;hp=10;level=1});
      Some (Monster {i=0;j=14;hp=10;level=1});
      Some (Monster {i=0;j=19;hp=10;level=1});
    ]
  |9 ->[
      Some (Monster {i=0;j=9;hp=10;level=1});
      Some (Monster {i=0;j=19;hp=10;level=1});
    ]
  |10 ->[
      Some (Monster {i=0;j=4;hp=10;level=1});
      Some (Monster {i=0;j=19;hp=10;level=1});
    ]
  |11 ->[
      Some (Monster {i=0;j=9;hp=10;level=1});
      Some (Monster {i=0;j=19;hp=10;level=1});
    ]
  |12 ->[
      Some (Monster {i=0;j=4;hp=10;level=1});
      Some (Monster {i=0;j=9;hp=10;level=1});
    ]
  |13 ->[
      Some (Monster {i=0;j=4;hp=10;level=1});
      Some (Monster {i=0;j=9;hp=10;level=1});
      Some (Monster {i=0;j=19;hp=10;level=1});
    ]
  |_-> [
      Some (Monster {i=0;j=14;hp=10;level=1});
      Some (Monster {i=0;j=24;hp=10;level=1});
    ]

(*[new_row_monsters2 count] creates a new row, full of monsters at the top of
  the board. This row varies depending on what value [count] is. These cases
  for [count] give us varied patterns for the monsters. These are all monsters
  at the middle difficulty*)
let new_row_monsters2 count =
  match count with
  |1->[
      Some (Monster {i=0;j=4;hp=20;level=2});
      Some (Monster {i=0;j=9;hp=20;level=2});
      Some (Monster {i=0;j=14;hp=20;level=2});
      Some (Monster {i=0;j=19;hp=20;level=2});
      Some (Monster {i=0;j=24;hp=20;level=2});
    ]
  |2-> [
      Some (Monster {i=0;j=4;hp=20;level=2});
      Some (Monster {i=0;j=14;hp=20;level=2});
      Some (Monster {i=0;j=24;hp=20;level=2});
    ]
  |3 ->[
      Some (Monster {i=0;j=4;hp=20;level=2});
      Some (Monster {i=0;j=9;hp=20;level=2});
      Some (Monster {i=0;j=19;hp=20;level=2});
    ]
  |4 ->[
      Some (Monster {i=0;j=4;hp=20;level=2});
      Some (Monster {i=0;j=9;hp=20;level=2});
      Some (Monster {i=0;j=24;hp=20;level=2});
    ]
  |5 ->[
      Some (Monster {i=0;j=14;hp=20;level=2});
      Some (Monster {i=0;j=19;hp=20;level=2});
    ]
  |6 ->[
      Some (Monster {i=0;j=9;hp=20;level=2});
      Some (Monster {i=0;j=24;hp=20;level=2});
    ]
  |7 ->[
      Some (Monster {i=0;j=4;hp=20;level=2});
      Some (Monster {i=0;j=9;hp=20;level=2});
      Some (Monster {i=0;j=14;hp=20;level=2});
      Some (Monster {i=0;j=19;hp=20;level=2});
    ]
  |8 ->[
      Some (Monster {i=0;j=9;hp=20;level=2});
      Some (Monster {i=0;j=14;hp=20;level=2});
      Some (Monster {i=0;j=19;hp=20;level=2});
    ]
  |9 ->[
      Some (Monster {i=0;j=9;hp=20;level=2});
      Some (Monster {i=0;j=19;hp=20;level=2});
    ]
  |10 ->[
      Some (Monster {i=0;j=4;hp=20;level=2});
      Some (Monster {i=0;j=19;hp=20;level=2});
    ]
  |11 ->[
      Some (Monster {i=0;j=9;hp=20;level=2});
      Some (Monster {i=0;j=19;hp=20;level=2});

    ]
  |12 ->[
      Some (Monster {i=0;j=4;hp=20;level=2});
      Some (Monster {i=0;j=9;hp=20;level=2});
    ]
  |13 ->[
      Some (Monster {i=0;j=4;hp=20;level=2});
      Some (Monster {i=0;j=24;hp=20;level=2});
    ]
  |_-> [
      Some (Monster {i=0;j=14;hp=20;level=2});
      Some (Monster {i=0;j=24;hp=20;level=2});
    ]

(*[new_row_monsters3_init count difficulty] creates a new row, full of monsters
  at the top of the board. This row varies depending on what value [count] is.
  These cases for [count] give us varied patterns for the monsters. These are
  all monsters at the hardest difficulty*)
let new_row_monsters3_init count difficulty =
  match count with
  |1->[
      Some (Monster {i=0;j=4;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=9;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=14;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=19;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=24;hp=20+(difficulty*5);level=3});
    ]
  |2-> [
      Some (Monster {i=0;j=4;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=14;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=24;hp=20+(difficulty*5);level=3});
    ]
  |3 ->[
      Some (Monster {i=0;j=4;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=9;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=19;hp=20+(difficulty*5);level=3});
    ]
  |4 ->[
      Some (Monster {i=0;j=4;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=9;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=24;hp=20+(difficulty*5);level=3});
    ]
  |5 ->[
      Some (Monster {i=0;j=14;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=19;hp=20+(difficulty*5);level=3});
    ]
  |6 ->[
      Some (Monster {i=0;j=9;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=24;hp=20+(difficulty*5);level=3});
    ]
  |7 ->[
      Some (Monster {i=0;j=4;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=9;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=14;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=19;hp=20+(difficulty*5);level=3});
    ]
  |8 ->[
      Some (Monster {i=0;j=9;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=14;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=19;hp=20+(difficulty*5);level=3});
    ]
  |9 ->[
      Some (Monster {i=0;j=9;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=19;hp=20+(difficulty*5);level=3});
    ]
  |10 ->[
      Some (Monster {i=0;j=4;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=19;hp=20+(difficulty*5);level=3});
    ]
  |11 ->[
      Some (Monster {i=0;j=9;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=19;hp=20+(difficulty*5);level=3});
    ]
  |12 ->[
      Some (Monster {i=0;j=4;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=9;hp=20+(difficulty*5);level=3});
    ]
  |13 ->[
      Some (Monster {i=0;j=4;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=24;hp=20+(difficulty*5);level=3});
    ]
  |_-> [
      Some (Monster {i=0;j=14;hp=20+(difficulty*5);level=3});
      Some (Monster {i=0;j=24;hp=20+(difficulty*5);level=3});
    ]


let raise_proj (proj : projectile): projectile =
  {proj with i = proj.i-1}

(*Initializes new projectiles*)
let new_projectiles =
  [Some (Projectile {i=42;j=16;collided = false});
   Some (Projectile {i=44;j=16;collided = false});
   Some (Projectile {i=46;j=16;collided = false})]
