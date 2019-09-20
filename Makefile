all: main

main: blind_api quotient_api fuzzer_api

blind_api: parserbnf.cmx lexerbnf.cmx base.ml parser.ml nettoyage.ml clean.ml quotient.ml blind.ml blind_api.ml
	ocamlopt str.cmxa parserbnf.cmx lexerbnf.cmx base.ml parser.ml nettoyage.ml clean.ml quotient.ml blind.ml blind_api.ml -g -o blind_api

quotient_api: parserbnf.cmx lexerbnf.cmx base.ml parser.ml nettoyage.ml clean.ml quotient.ml blind.ml quotient_api.ml
	ocamlopt str.cmxa parserbnf.cmx lexerbnf.cmx base.ml parser.ml nettoyage.ml clean.ml quotient.ml blind.ml quotient_api.ml -g -o quotient_api

fuzzer_api: parserbnf.cmx lexerbnf.cmx base.ml parser.ml nettoyage.ml clean.ml quotient.ml blind.ml fuzzer_api.ml
	ocamlopt str.cmxa parserbnf.cmx lexerbnf.cmx base.ml parser.ml nettoyage.ml clean.ml quotient.ml blind.ml fuzzer_api.ml -g -o fuzzer_api

clean:
	rm -f *.cm* *.o *_api

parserbnf.cmx lexenbnf.cmx: lexerbnf.mll parserbnf.mly
	ocamllex lexerbnf.mll
	ocamlyacc parserbnf.mly
	ocamlc -c parserbnf.mli
	ocamlopt -c parserbnf.ml
	ocamlopt -c lexerbnf.ml
