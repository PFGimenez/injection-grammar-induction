let ()=
    let prefix = ref None
    and suffix = ref None
    and goal = ref []
    and injg_fname = ref None
    and oneline_comment = ref None
    and grammar_fname = ref None
    and qgraph_fname = ref None in

    let speclist = [
        ("-grammar",    Arg.String (fun s -> grammar_fname := Some s),     "Target grammar");
        ("-prefix",         Arg.String (fun s -> prefix := Some s),     "Prefix of the request");
        ("-suffix",         Arg.String (fun s -> suffix := Some s),     "Suffix of the request");
        ("-goal",       Arg.String (fun s -> goal := (Poirot.read_token s) :: !goal),     "Terminal or nonterminal to reach");
        ("-injg",       Arg.String (fun s -> injg_fname := Some s),     "Export the injection grammar in ANTLR4 format");
        ("-oneline_comment",     Arg.String (fun s -> oneline_comment := Some s),    "The string that starts one-line comment");
        ("-qgraph",     Arg.String (fun s -> qgraph_fname := Some s),    "Save the quotient graph")
    ] in
    Arg.parse speclist ignore ("Whitebox utility. Poirot v"^Poirot.version);

    if !grammar_fname <> None && !prefix <> None && !suffix <> None then begin
        let prefix = Option.get !prefix
        and suffix = Option.get !suffix
        and grammar_fname = Option.get !grammar_fname in

        let inj_g,word,reached = Poirot.whitebox_search ~oneline_comment:!oneline_comment ~qgraph_fname:!qgraph_fname grammar_fname prefix suffix !goal in
        print_endline (Poirot.string_of_grammar inj_g);
        Option.iter (fun fname -> print_endline ("Injection grammar saved into "^(fname)^".g4"); Poirot.export_antlr4 fname inj_g) !injg_fname;
        if word = [] then
            print_endline "No injection"
        else if reached && !goal <> [] then
            List.iter (fun w -> print_endline ("Injection (goal reached): "^w)) word
        else if !goal <> [] then
            List.iter (fun w -> print_endline ("Injection (goal impossible to reach): "^w)) word
        else
            List.iter (fun w -> print_endline ("Injection: "^w)) word
    end else print_endline "Error: grammar, prefix and suffix are necessary"

