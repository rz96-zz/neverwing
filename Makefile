# the resulting working website is to be found in _build/html
#what is this lmao
all:
	ocamlbuild -use-ocamlfind \
	  -plugin-tag "package(js_of_ocaml.ocamlbuild)" \
	  -no-links \
	  gui.js
		#	ocamlbuild -use-ocamlfind -plugin-tag 'package(js_of_ocaml.ocamlbuild)' \
		#							 src/ex1.js

clean:
	ocamlbuild -clean
