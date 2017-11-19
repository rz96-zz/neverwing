open Character

(*Type sprite_props represents the properties that a
sprite would have in the game*)
type sprite_props = {
  img_src: string;
  frame_size: Character.xy;
  frame_offset: Character.xy;
}

type sprite = {
  mutable property : sprite_props;
  context: Dom_html.canvasRenderingContex2tD Js.t;
  mutable image : Dom_html.imageElement Js.t;
}
