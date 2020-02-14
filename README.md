# Poirot: grammar-based injection fuzzer for black box systems
  
_Poirot is still a work in progress_
  
## Install the library

First, install the Ocaml package manager, `opam`: https://opam.ocaml.org/doc/Install.html

Then, clone the Poirot repository: `git clone https://github.com/PFGimenez/poirot.git`

Go into the directory `poirot/poirot`.

Finally, install Poirot: `opam pin poirot .` and then `opam install .`

To generate the documentation, make sure `odoc` is installed or install it with `opam install odoc`. You can then generate the documentation with `dune build @doc`. It will be stored in `poirot/_build/default/_doc/`.

## Use the library in your own project

Using Poirot in your project with `dune` is easy: just add `poirot` in the list of the dependencies. Poirot should be available to `ocamlfind` as well (you can check with `ocamlfind query poirot`).

Check `poirot/poirot/examples/poirot_example.ml` for an example.

## Use the ANTLR4 ⇌ BNF converter

Poirot uses a simple grammar format inspired from the BNF format.

### Install antlr4

You will certainly need ANTLR4. Make sure you have Python 3 and Java JRE installed. Go into the directory `antlr4-utils` and execute `pip3 install -r requirements.txt`

### ANTLR4 → BNF

You can find many grammars in ANTLR4 format in this repository: https://github.com/antlr/grammars-v4.

Go into the directory `antlr4-utils`. If you have a grammar named `test.g4`, you can simply write `make test.bnf` to generate its BNF version. The Makefile will automatically download the ANTLR4 jar file if necessary.

### BNF → ANTLR4

Make sure the project is built. Otherwise, run `dune build` in the `poirot` directory.

Go into the directory `poirot/_build/default/examples`. If you have a grammar `test.bnf`, run `./bnf2antlr4.exe test.bnf`. It will generate the file `test.g4`. Its axiom is named `axiom`.

## Oracles

The oracles are in the directory `oracles`.

### What is an oracle ?

(TODO)

### Use the prefix/suffix oracle

Put an ANTLR4 grammar (such as `example.g4`) into the `antlr4-utils` directory. Execute `make exampleLexer.py` (change accordingly to the name of your grammar). For example, you can use the simple `msg_exec.g4` grammar; in this case, type `make msg_execLexer.py`.

## Run the example with the prefix/suffix oracle

Make sure the project is built. Otherwise, run `dune build` in the `poirot` directory.

Go into the directory `poirot/_build/default/examples`.

Run the example with: `./poirot_example.exe -grammar ../../../../bnf_grammars/msg_exec.bnf -goal "Exe" -start "'value'" -oracle "../../../../oracles/prefix-suffix.py msg_exec axiom 'msg key = ' ' & key = value'"`
