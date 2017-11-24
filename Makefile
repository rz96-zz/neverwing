all: byte
	js_of_ocaml main2.byte

byte:
	ocamlbuild -use-ocamlfind -pkgs js_of_ocaml-lwt,js_of_ocaml.ppx,lwt.ppx main2.byte
