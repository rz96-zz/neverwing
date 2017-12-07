all: bytecmo
	js_of_ocaml main2.byte

bytecmo:
	ocamlbuild -use-ocamlfind -pkgs js_of_ocaml-lwt,js_of_ocaml.ppx,lwt.ppx main2.byte sprite.cmo state.cmo collision.cmo board.cmo gui.cmo command.cmo

clean:
	ocamlbuild -clean
	rm *.js
