all: bytecmo
	js_of_ocaml main2.byte

bytecmo:
	ocamlbuild -use-ocamlfind -pkgs js_of_ocaml-lwt,js_of_ocaml.ppx,lwt.ppx main2.byte sprite.cmo sprite.cmi state.cmo state.cmi character.cmo character.cmi board.cmo board.cmi gui.cmo gui.cmi command.cmo command.cmi

clean:
	ocamlbuild -clean
	rm *.js
