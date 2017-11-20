type width_height = float * float
type x_y = float * float

type sprite_props = 
  {
    img_src: string;
    frame_size: width_height;
    frame_offset: x_y;
  }

type sprite = {
  mutable prop: sprite_props;
  context: Dom_html.canvasRenderingContext2D Js.t;
  mutable img: Dom_html.imageElement Js.t;
}

let init_sprite img_src frame_size frame_offset = 
  let img_src = "./sprites/" ^ img_src in
  {
    img_src;
    frame_size;
    frame_offset;
  }

let make_sprite prop context = 
  let img = (Dom_html.createImg Dom_html.document) in
  img##src <- (Js.string prop.img_src);
  { 
    prop;
    context;
    img;
  }

let init_bgd context = 
  let prop = init_sprite "bgd.png" (500., 600.) (0., 0.) in 
  make_sprite prop context