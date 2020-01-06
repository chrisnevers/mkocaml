open IoUtils

let username      = exec "git config user.name"
let email         = exec "git config user.email"
let dune_version  = exec "dune --version"

let account = 
  let open String in
  username |> lowercase_ascii |> split_on_char ' '  |> concat ""

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

let setup_git () =
  cmd_ "git init";
  write_file ".gitignore" gitignore
