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

let makefile project project_type =
  let copy_exe = match project_type with
  | `Exec -> "\t@cp -f _build/default/bin/main.exe /usr/local/bin/" ^ project
  | _     -> ""
  in
  Format.sprintf
"all: build

build: 
\t@dune build @all
%s

install:
\t@dune install

test: build
\t@dune runtest

doc: build
\t@opam install odoc
\t@dune build @doc
  
clean:
\t@dune clean

publish:
\t@opam pin .
\t@opam publish .
" 
  copy_exe

let opam project =
  Format.sprintf
"
opam-version: \"2.0\"
version: \"1.0\"
authors: \"Chris Nevers <christophernevers96@gmail.com>\"
maintainer: \"Chris Nevers <christophernevers96@gmail.com>\"
homepage: \"https://github.com/chrisnevers/%s\"
bug-reports: \"https://github.com/chrisnevers/%s/issues\"
dev-repo: \"git://github.com/chrisnevers/%s.git\"
synopsis: \"\"
build: [
  [\"dune\" \"subst\"] {pinned}
  [\"dune\" \"build\" \"-p\" name \"-j\" jobs]
]

depends: [
  \"dune\" {build}
  \"alcotest\" {with-test}
]
"
project project project

let gitignore = 
"
*.annot
*.cmo
*.cma
*.cmi
*.a
*.o
*.cmx
*.cmxs
*.cmxa

# ocamlbuild working directory
_build/

# ocamlbuild targets
*.byte
*.native

# oasis generated files
setup.data
setup.log

# Merlin configuring file for Vim and Emacs
.merlin

# Dune generated files
*.install

# Local OPAM switch
_opam/
notes
*DS_Store
"

let setup_opam project =
  match Sys.file_exists (project ^ ".opam") with
  | true -> ()
  | false ->
    let chan = open_out (project ^ ".opam") in
    output_string chan (opam project);
    close_out chan;
    let _ = Sys.command "dune build @install" in 
    ()

let setup_exe project =
  let _ = Format.sprintf "mkdir -p bin && cd bin && dune init exec %s" project 
          |> Sys.command in
  begin match Sys.file_exists "Makefile" with
  | true -> ()
  | false ->
    let chan = open_out "Makefile" in
    output_string chan (makefile project `Exec);
    close_out chan
  end;
  setup_opam project

let setup_lib project =
  let _ = Format.sprintf 
            "mkdir -p lib && cd lib && dune init lib %s && mv ../dune . && touch %s.ml" 
            project project
          |> Sys.command in
  begin match Sys.file_exists "Makefile" with
  | true -> ()
  | false ->
    let chan = open_out "Makefile" in
    output_string chan (makefile project `Lib);
    close_out chan
  end;
  setup_opam project

let setup_git () =
  let _ = Sys.command ("git init"); in
  let chan = open_out ".gitignore" in
  output_string chan gitignore;
  close_out chan

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
