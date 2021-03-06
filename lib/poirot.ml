type grammar = Grammar.grammar
type element = Grammar.element

let version = "0.4"

let search ?(inference_g: grammar option = None) ?(heuristic: Inference.heuristic = Inference.COMPLICATED) ?(manual_stop: bool = false) ?(oneline_comment: string option = None) ?(dict: (element,string) Hashtbl.t option = None) ?(max_depth: int = 10) ?(max_steps: int = 1000) ?(forbidden_chars: char list = []) ?(sgraph_fname: string option = None) ?(qgraph_fname: string option = None) ?(save_h: bool = true) ?(save_oracle: bool = true) (oracle: Oracle.t) (g: grammar) (goal: element) (start: element list) : (grammar * string) option =

    (* heuristic save file *)
    let h_fname = if save_h then Some ((string_of_int (Hashtbl.hash g + Hashtbl.hash goal))^".prt") else None in

    (* oracle save file *)
    let o_fname = if save_oracle then Some ((string_of_int (Hashtbl.hash g + Hashtbl.hash goal))^"_oracle.prt") else None in

    match Inference.search oracle inference_g g goal start oneline_comment dict max_depth max_steps sgraph_fname qgraph_fname h_fname o_fname forbidden_chars manual_stop heuristic with
    | None -> None
    | Some (g,w) -> Some ((Grammar.grammar_of_ext_grammar g), w)

let read_dict : string -> (element,string) Hashtbl.t = Grammar_io.read_dict

let whitebox_search ?(oneline_comment: string option = None) ?(qgraph_fname: string option = None) (grammar_fname: string) (prefix: string) (suffix: string) (goal: element option) : (grammar * string option * bool) =
    let g = Grammar_io.read_bnf_grammar true grammar_fname in
    let explode s = List.init (String.length s) (fun i -> Grammar.Terminal (String.make 1 (String.get s i))) in
    let prefix = explode prefix
    and suffix = explode suffix in
    let quotient = Quotient.init oneline_comment g [] None qgraph_fname in
    let e : Grammar.ext_element = {pf=List.rev prefix;e=g.axiom;sf=suffix} in
    let inj,goal_reached = Quotient.get_injection quotient e goal in
    let g = Quotient.get_grammar quotient e in
    let g2 = Grammar.grammar_of_ext_grammar (Clean.clean g) in
    (g2,Option.map Grammar.string_of_word inj,goal_reached)

let to_uppercase (g: grammar) = Clean.to_uppercase g
let to_lowercase (g: grammar) = Clean.to_lowercase g

let set_axiom (g: grammar) (axiom: element) : grammar = {axiom; rules=g.rules}

let string_of_grammar : grammar -> string = Grammar.string_of_grammar
let read_bnf_grammar ?(unravel: bool = false) : string -> grammar = Grammar_io.read_bnf_grammar unravel
let read_tokens ?(unravel: bool = false) :  string -> element list = Grammar_io.read_tokens unravel
let read_token ?(unravel: bool = false) :  string -> element = Grammar_io.read_token unravel

let export_antlr4 : string -> grammar -> unit = Grammar_io.export_antlr4

let set_log_level (lvl: Logs.level option) : unit = Logs.Src.set_level Log.poirotsrc lvl
let set_reporter (r: Logs.reporter) : unit = Logs.set_reporter r;
