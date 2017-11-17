open Character

(*Type sprite_props represents the properties that a
sprite would have in the game*)
type sprite_props = {
  image_location: string;
  frame_size: Character.xy;
}

type sprite = {
  mutable property : sprite_props;
  mutable image : Dom_html.imageElement Js.t;
}
