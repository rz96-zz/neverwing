open Command
open Board


(*[get_obj_bounds obj] takes [obj] and determines the bounding parameters
  of the object. It returns the parameters in a tuple of type
  int*int*int*int. The values correspond to the parameters
  (bottom row, left column, top row, right column). *)
let get_obj_bounds obj =
  match obj with
  | (Some(Monster m)) -> if (m.level = 4) then
      (m.i, m.j, m.i + 5, m.j + 5) else (m.i, m.j, m.i + 2, m.j + 2)
  | (Some(Player p)) -> (p.i, p.j, p.i + 1, p.j+2)
  | (Some(Projectile pro)) -> (pro.i, pro.j, pro.i, pro.j)
  | None -> (0, 0, 0, 0)

let check_collision obj1 obj2 =
  let bounds1 = get_obj_bounds obj1 and bounds2 = get_obj_bounds obj2 in
  match (bounds1, bounds2) with
  | ((bottom_row1, left_col1, top_row1, right_col1), (bottom_row2, left_col2, top_row2, right_col2))
    -> if  (top_row1 = bottom_row2 || top_row2 = bottom_row1) &&
         (left_col1 <= right_col2) && (right_col1 >= left_col2)
    then true else false
