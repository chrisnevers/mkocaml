open IoUtils
open GitUtils
open MakefileUtils
open OpamUtils

let lib_name = ref ""
let exe_name = ref ""

let bad_arg arg =
  raise @@ Arg.Bad (Format.sprintf "Unrecognized argument: %s" arg)

let usage =
  Format.sprintf "Usage: %s [-l name] [-e name]" Sys.argv.(0)

let specs = [
  "-l", Arg.Set_string lib_name, ": Creates a library with the given name";
  "-e", Arg.Set_string exe_name, ": Creates an executable with the given name";
]

let setup_exe project =
  Format.sprintf "dune init exec %s bin" project |> cmd_;
  if Sys.file_exists "Makefile" |> not then
    makefile project `Exec account |> write_file "Makefile";
  setup_opam project

let setup_lib project =
  Format.sprintf "dune init lib %s lib --inline-tests && touch lib/%s.ml"
    project project |> cmd_;
  if Sys.file_exists "Makefile" |> not then
    makefile project `Lib account |> write_file "Makefile";
  setup_opam project

let () =
  Arg.parse specs bad_arg usage;
  if String.length !lib_name > 0 then
    let _ = setup_git () in
    setup_lib !lib_name
  else
  if String.length !exe_name > 0 then
    let _ = setup_git () in
    setup_exe !exe_name
  else
    print_endline usage
