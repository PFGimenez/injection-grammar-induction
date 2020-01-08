let oracle_from_script (fname: string) (inj: string) : bool =
    let cmd = fname^" '"^inj^"'" in
    let out =  (Sys.command cmd) == 0 in
    print_endline ("Call to oracle: "^cmd^": "^(string_of_bool out));
    out

let ()=
    let graph_fname = ref None in
    let injg_fname = ref None in
    let max_depth = ref 5 in
    let grammar = ref None in
    let oracle_fname = ref None in
    let goal = ref None in

    let speclist = [
        ("-grammar",    Arg.String (fun s -> grammar := Some(Grammar_io.read_bnf_grammar s)),     "Target grammar");
        ("-goal",         Arg.String (fun s -> goal := Some(List.hd (Grammar_io.read_tokens s))),     "Terminal or nonterminal to reach");
        ("-oracle",    Arg.String (fun s -> oracle_fname := Some(s)),     "Oracle script filename");
        ("-maxdepth",   Arg.Set_int max_depth,    "Set the max depth search (default: "^(string_of_int !max_depth)^")");
        ("-graph",      Arg.String (fun s -> graph_fname := Some(s)),    "Save the search graph");
        ("-injg",       Arg.String (fun s -> injg_fname := Some(s)),     "Save the injection grammar")
    ] in
    let usage = "Error: grammar, goal and oracle are necessary" in
    Arg.parse speclist ignore usage;

    if !grammar <> None && !oracle_fname <> None && !goal <> None then
        let grammar = Option.get !grammar
        and goal = Option.get !goal
        and oracle_fname = Option.get !oracle_fname in

        let fuzzer = Tree_fuzzer.fuzzer in

        let fuzzer_oracle (g: Grammar.grammar) : bool = g |> fuzzer |> Grammar.string_of_word |> oracle_from_script oracle_fname in

        let g = Blind.search fuzzer_oracle grammar goal !max_depth !graph_fname in match g with
        | None -> print_endline "No grammar found"
        | Some(inj_g) -> print_endline ("Injection:  "^(Grammar.string_of_word (fuzzer (Grammar.grammar_of_ext_grammar inj_g)))); Option.iter (fun f -> Grammar_io.export_bnf f inj_g) !injg_fname
    else print_endline usage