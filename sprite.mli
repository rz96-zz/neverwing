(*Type sprite_props represents the properties that a
sprite would have in the game*)
type sprite_props = {
  img_src: string;
  frame_size: float*float;
  frame_offset: float*float;
}

type sprite = {
  mutable prop : sprite_props;
  context: Dom_html.canvasRenderingContext2D Js.t;
  mutable img : Dom_html.imageElement Js.t;
}

val init_sprite : string -> float*float -> float*float -> sprite_props

val make_sprite : sprite_props -> Dom_html.canvasRenderingContext2D Js.t -> sprite

val init_bgd: Dom_html.canvasRenderingContext2D Js.t  -> sprite