
OBJS= sprite.cmo character.cmo board.cmo gui.cmo state.cmo command.cmo
NAME=main2
OCAMLC=ocamlfind ocamlc -thread -package js_of_ocaml-lwt -package js_of_ocaml.ppx -package lwt.ppx
$(NAME).byte: $(OBJS)
	$(OCAMLC) -linkpkg -o $@ $(OBJS) $(NAME).ml

$(NAME).js: $(NAME).byte
	js_of_ocaml $<

%.cmo: %.ml
	$(OCAMLC) -c $<i
	$(OCAMLC) -c $<

clean: 
	ocamlbuild -clean
	rm *.cm*
	rm *.byte
