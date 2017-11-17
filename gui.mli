open State
open Character

(*Draw the player's score in the GUI*)
val draw_score: Dom_html.canvasRenderingContext2D Js.t -> unit

(*Draw "game over" state in the GUI*)
val game_over: Dom_html.canvasRenderingContext2D Js.t -> unit

(*Draw characters in the GUI*)
val draw_char: Character.sprite -> float * float-> unit

(* Draws the fps on the canvas *)
val fps : Dom_html.canvasElement Js.t -> float -> unit

(* Draw the given sprite as a background *)
val draw_bgd : Sprite.sprite -> float -> unit
