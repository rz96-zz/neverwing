open State
open Character

(*Draw score GUI*)
val draw_score: Dom_html.canvasRenderingContext2D Js.t -> unit

(*Draw game over GUI*)
val game_over: Dom_html.canvasRenderingContext2D Js.t -> unit

(*Draw characters*)
val draw_char: Character.sprite -> float * float-> unit

